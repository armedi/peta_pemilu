defmodule PetaPemiluWeb.CandidateHTML do
  use PetaPemiluWeb, :html

  def show(assigns) do
    ~H"""
    <form action={@url} method="post" enctype="multipart/form-data">
      <%= for {key, value} <- @data do %>
        <input type="hidden" name={key} value={value} />
      <% end %>
    </form>
    <script>
      document.querySelector("form").submit();
    </script>
    """
  end
end
