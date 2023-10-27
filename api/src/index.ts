import { Elysia } from "elysia";
import postgres from "postgres";

const sql = postgres(process.env.DATABASE_URL!, {
  max: 1,
  ssl: "require",
});

const app = new Elysia()
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
  .get("/area/:coordinate", async ({ set, params }) => {
    const [lat, lon] = params.coordinate.split(",");

    let location =
      await sql`SELECT * FROM kel_desa WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint(${lon}, ${lat}), 104199));`;

    if (location.length === 0) {
      location = await sql`SELECT * FROM kecamatan WHERE st_intersects(geom, ST_SetSRID(ST_MakePoint(${lon}, ${lat}), 104199));`;
    }

    if (location.length === 0) {
      set.status = 404;
      return {
        message: "Area not found",
      };
    }

    return location[0];
  })
  .listen(process.env.PORT!);

console.log(
  `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
