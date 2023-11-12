import { Elysia } from "elysia";
import postgres from "postgres";
import { logger } from "@bogeychan/elysia-logger";
import { PlainObject, omit } from "moderndash";

const sql = postgres(process.env.DATABASE_URL!, {
  max: 1,
  ssl: "require",
});

const app = new Elysia()
  .use(
    logger({
      level: "error",
    })
  )
  .onError(({ set, error, code, log }) => {
    switch (code) {
      case "VALIDATION":
        set.status = 400;
        return {
          message: "Invalid coordinate",
        };
      default:
        log?.error(error.message || "Unknown error");
        set.status = 500;
        return {
          message: error.message,
        };
    }
  })
  .get("/up", async () => {
    return "";
  })
  .get("/api/v1/area/:coordinate", async ({ set, params }) => {
    const [lat, lon] = params.coordinate.split(",");

    let kelDesa =
      await sql`SELECT kode_kd, kode_kec, kode_kk, kode_prov, kel_desa, kecamatan, kab_kota, provinsi, ST_AsGeoJSON(geom) AS geojson FROM kel_desa WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint(${lon}, ${lat}), 104199))`;

    let kecamatanPromise =
      kelDesa.length === 0
        ? sql`SELECT kode_kec, kode_kk, kode_prov, kecamatan, kab_kota, provinsi, ST_AsGeoJSON(ST_Simplify(geom, 0.0001)) AS geojson FROM kecamatan WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint(${lon}, ${lat}), 104199))`
        : sql`SELECT ST_AsGeoJSON(ST_Simplify(geom, 0.0001)) AS geojson FROM kecamatan WHERE kode_kec = ${kelDesa[0].kode_kec}`;

    // only await kecamatanPromise here if we really need to,
    // otherwise it's only awaited on the Promise.all below
    const attributes: any = omit(
      (kelDesa.length === 0
        ? (await kecamatanPromise)[0]
        : kelDesa[0]) as PlainObject,
      ["geojson"]
    );

    const [kecamatan, kabKota, provinsi] = await Promise.all([
      kecamatanPromise,
      sql`SELECT ST_AsGeoJSON(ST_Simplify(geom, 0.001)) AS geojson FROM kab_kota WHERE kode_kk = ${attributes.kode_kk}`,
      sql`SELECT ST_AsGeoJSON(ST_Simplify(geom, 0.01)) AS geojson FROM provinsi WHERE kode_prov = ${attributes.kode_prov}`,
    ]);

    if (
      [kelDesa.length, kecamatan.length, kabKota.length, provinsi.length].every(
        (x) => x === 0
      )
    ) {
      set.status = 404;
      return {
        message: "Area not found",
      };
    }

    set.headers["Cache-Control"] = "public, max-age=31536000, immutable"; // 1 year

    return {
      ...attributes,
      batas: {
        kel_desa: kelDesa[0] ? JSON.parse(kelDesa[0].geojson) : null,
        kecamatan: JSON.parse(kecamatan[0].geojson),
        kab_kota: JSON.parse(kabKota[0].geojson),
        provinsi: JSON.parse(provinsi[0].geojson),
      },
    };
  })
  .listen(process.env.PORT!);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
