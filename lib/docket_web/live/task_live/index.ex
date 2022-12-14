defmodule DocketWeb.TaskLive.Index do
  use DocketWeb, :live_view

  alias Docket.Tasks
  alias Docket.Schema
  alias Docket.Time

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:now, Time.now())
      |> assign(:tasks, list_tasks())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Schema.Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_event("complete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.complete_task(task)

    {:noreply, assign(socket, :tasks, list_tasks())}
  end

  def handle_event("snooze", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.snooze_task(task)

    {:noreply, assign(socket, :tasks, list_tasks())}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, assign(socket, :tasks, list_tasks())}
  end

  defp list_tasks do
    Tasks.list_tasks()
  end

  defp current_appointment_date(task), do: Tasks.current_appointment(task).scheduled_for
end
