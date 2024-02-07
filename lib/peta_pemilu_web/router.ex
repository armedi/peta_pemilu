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

    # get "/caleg/dpd/:dapil/:candidate_number", CandidateController, :dpd
    get "/caleg/dpd/:dapil/:id", CandidateController, :dpd
    live "/caleg/dpd/:dapil", Live.Dpd

    live "/caleg/dpr/:dapil/:party/:candidate_number", Live.Dpr.CandidateProfile
    # get "/caleg/dpr/:dapil/:id", CandidateController, :dpr
    live "/caleg/dpr/:dapil", Live.Dpr

    live "/caleg/dprd-prov/:dapil/:party/:candidate_number", Live.DprdProv.CandidateProfile
    # get "/caleg/dprd-prov/:dapil/:id", CandidateController, :dprd_prov
    live "/caleg/dprd-prov/:dapil", Live.DprdProv

    live "/caleg/dprd-kabko/:dapil/:party/:candidate_number", Live.DprdKabko.CandidateProfile
    # get "/caleg/dprd-kabko/:dapil/:id", CandidateController, :dprd_kabko
    live "/caleg/dprd-kabko/:dapil", Live.DprdKabko

    live "/:map_view", Live.Index
    live "/", Live.Index
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
