defmodule PetaPemiluWeb.Router do
  use PetaPemiluWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PetaPemiluWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PetaPemiluWeb do
    pipe_through :browser

    live "/", Live.Index

    get "/caleg/dpd/:slug/:id", CandidateController, :dpd
    get "/caleg/dpr/:slug/:id", CandidateController, :dpr
    get "/caleg/dprd-prov/:slug/:id", CandidateController, :dprd_prov
    get "/caleg/dprd-kabko/:slug/:id", CandidateController, :dprd_kabko

    live "/:map_view", Live.Index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PetaPemiluWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:peta_pemilu, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PetaPemiluWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
