import { Elysia } from "elysia";
import postgres from "postgres";
import { logger } from "@bogeychan/elysia-logger";

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
  .onError(({ set, error, code }) => {
    switch (code) {
      case "VALIDATION":
        set.status = 400;
        return {
          message: "Invalid coordinate",
        };
      default:
        set.status = 500;
        return {
          message: "Internal server error",
        };
    }
  })
  .get("/up", async () => {
    return {
      message: "Ok",
    };
  })
  .get("/area/:coordinate", async ({ set, params }) => {
    const [lat, lon] = params.coordinate.split(",");

    let location =
      await sql`SELECT ST_AsGeoJSON(t) AS geojson_feature FROM (SELECT * FROM kel_desa WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint(${lon}, ${lat}), 104199))) AS t`;

    if (location.length === 0) {
      location =
        await sql`SELECT ST_AsGeoJSON(t) AS geojson_feature FROM (SELECT * FROM kecamatan WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint(${lon}, ${lat}), 104199))) AS t`;
    }

    if (location.length === 0) {
      set.status = 404;
      return {
        message: "Area not found",
      };
    }

    return location[0].geojson_feature;
  })
  .listen(process.env.PORT!);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
