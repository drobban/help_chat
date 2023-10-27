defmodule HelpChatWeb.RoomChannel do
  use HelpChatWeb, :channel

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), {:after_join, payload})
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_info({:after_join, payload}, socket) do
    broadcast(socket, "present", payload)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", _payload, socket) do
    response_data = %{"message" => "pong!"}
    {:reply, {:ok, response_data}, socket}
  end

  @impl true
  def handle_in("message", %{"message" => msg} = _payload, socket) do
    IO.inspect("#{inspect socket}")
    response_data = %{"message" => "#{socket.join_ref}: #{msg}\n"}

    broadcast(socket, "shout", %{"response" => response_data})
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_in("present", payload, socket) do
    broadcast(socket, "present", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
