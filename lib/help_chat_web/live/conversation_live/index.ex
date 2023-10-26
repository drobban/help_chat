defmodule HelpChatWeb.ConversationLive.Index do
  use HelpChatWeb, :live_view


  @impl true
  def mount(_params, _session, socket) do
    HelpChatWeb.Endpoint.subscribe("room:lobby")
    HelpChatWeb.Endpoint.broadcast("room:lobby", "ident", %{data: "test"})
    socket =
      socket
      |> assign(:conversations, [])

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => _id}) do
    socket
    |> assign(:page_title, "Edit Conversation")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Conversation")
    |> assign(:conversation, %{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Conversations")
    |> assign(:conversation, nil)
  end

  @impl true
  def handle_info({HelpChatWeb.ConversationLive.FormComponent, {:saved, conversation}}, socket) do
    {:noreply, stream_insert(socket, :conversations, conversation)}
  end


  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{topic: _topic, event: "ident", payload: payload}, socket) do
    IO.inspect("Got ident event: #{inspect payload}")

    {:noreply, socket}
  end

  @impl true
  def handle_info(%Phoenix.Socket.Broadcast{topic: _topic, event: "present", payload: %{"user" => user}}, socket) do
    socket =
      socket
      |> assign(:users, [user])

    IO.inspect("Users: #{inspect socket[:users]}")

    {:noreply, socket}
  end

end
