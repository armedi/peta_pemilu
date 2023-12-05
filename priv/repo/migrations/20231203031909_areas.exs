defmodule MyApp.Repo.Migrations.CreateTables do
  use Ecto.Migration

  def up do
    execute """
    CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;
    """

    execute """
    COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';
    """

    execute """
    CREATE TABLE IF NOT EXISTS public.provinsi (
        gid integer PRIMARY KEY NOT NULL,
        kode_prov character varying(50),
        provinsi character varying(50),
        fid character varying(10),
        geom public.geometry(MultiPolygonZM,104199)
    );
    """

    execute """
    CREATE SEQUENCE IF NOT EXISTS public.provinsi_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    """

    execute """
    ALTER SEQUENCE public.provinsi_gid_seq OWNED BY public.provinsi.gid;
    """

    execute """
    CREATE TABLE IF NOT EXISTS public.kab_kota (
        gid integer PRIMARY KEY NOT NULL,
        kode_kk character varying(50),
        kode_prov character varying(50),
        kab_kota character varying(50),
        provinsi character varying(50),
        fid character varying(10),
        geom public.geometry(MultiPolygonZM,104199)
    );
    """

    execute """
    CREATE SEQUENCE IF NOT EXISTS public.kab_kota_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    """

    execute """
    ALTER SEQUENCE public.kab_kota_gid_seq OWNED BY public.kab_kota.gid;
    """

    execute """
    CREATE TABLE IF NOT EXISTS public.kecamatan (
        gid integer PRIMARY KEY NOT NULL,
        kode_kec character varying(50),
        kode_kk character varying(50),
        kode_prov character varying(50),
        kecamatan character varying(50),
        kab_kota character varying(50),
        provinsi character varying(50),
        fid character varying(254),
        geom public.geometry(MultiPolygonZM,104199)
    );
    """

    execute """
    CREATE SEQUENCE IF NOT EXISTS public.kecamatan_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    """

    execute """
    ALTER SEQUENCE public.kecamatan_gid_seq OWNED BY public.kecamatan.gid;
    """

    execute """
    CREATE TABLE IF NOT EXISTS public.kel_desa (
      gid integer PRIMARY KEY NOT NULL,
      fid numeric,
      name character varying(250),
      kode_kec character varying(50),
      kode_kd character varying(50),
      kode_kk character varying(50),
      kode_prov character varying(50),
      tipe_kd numeric,
      kecamatan character varying(50),
      kel_desa character varying(50),
      kab_kota character varying(50),
      provinsi character varying(50),
      jenis_kd character varying(254),
      geom public.geometry(MultiPolygonZM,104199)
    );
    """

    execute """
    CREATE SEQUENCE IF NOT EXISTS public.kel_desa_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
    """

    execute """
    ALTER SEQUENCE public.kel_desa_gid_seq OWNED BY public.kel_desa.gid;
    """

    execute """
    ALTER TABLE ONLY public.provinsi ALTER COLUMN gid SET DEFAULT nextval('public.provinsi_gid_seq'::regclass);
    """

    execute """
    ALTER TABLE ONLY public.kab_kota ALTER COLUMN gid SET DEFAULT nextval('public.kab_kota_gid_seq'::regclass);
    """

    execute """
    ALTER TABLE ONLY public.kecamatan ALTER COLUMN gid SET DEFAULT nextval('public.kecamatan_gid_seq'::regclass);
    """

    execute """
    ALTER TABLE ONLY public.kel_desa ALTER COLUMN gid SET DEFAULT nextval('public.kel_desa_gid_seq'::regclass);
    """

    execute """
    CREATE INDEX IF NOT EXISTS provinsi_geom_idx ON public.provinsi USING gist (geom);
    """

    execute """
    CREATE INDEX IF NOT EXISTS kab_kota_geom_idx ON public.kab_kota USING gist (geom);
    """

    execute """
    CREATE INDEX IF NOT EXISTS kecamatan_geom_idx ON public.kecamatan USING gist (geom);
    """

    execute """
    CREATE INDEX IF NOT EXISTS kel_desa_geom_idx ON public.kel_desa USING gist (geom);
    """
  end

  def down do
    execute """
    DROP INDEX IF EXISTS public.kel_desa_geom_idx;
    """

    execute """
    DROP TABLE IF EXISTS public.kel_desa;
    """

    execute """
    ALTER SEQUENCE public.kel_desa_gid_seq OWNED BY NONE;
    """

    execute """
    DROP INDEX IF EXISTS public.kecamatan_geom_idx;
    """

    execute """
    DROP TABLE IF EXISTS public.kecamatan;
    """

    execute """
    ALTER SEQUENCE public.kecamatan_gid_seq OWNED BY NONE;
    """

    execute """
    DROP INDEX IF EXISTS public.kab_kota_geom_idx;
    """

    execute """
    DROP TABLE IF EXISTS public.kab_kota;
    """

    execute """
    ALTER SEQUENCE public.kab_kota_gid_seq OWNED BY NONE;
    """

    execute """
    DROP INDEX IF EXISTS public.provinsi_geom_idx;
    """

    execute """
    DROP TABLE IF EXISTS public.provinsi;
    """

    execute """
    ALTER SEQUENCE public.provinsi_gid_seq OWNED BY NONE;
    """
  end
end
