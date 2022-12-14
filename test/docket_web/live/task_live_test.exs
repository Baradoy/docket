defmodule DocketWeb.TaskLiveTest do
  use DocketWeb.ConnCase

  import Phoenix.LiveViewTest

  import Docket.Factory

  @create_attrs %{
    display_colour: "some display_colour",
    display_icon: :bolt,
    frequency: 42,
    frequency_type: :hours,
    subtitle: "some subtitle",
    title: "some title",
    type: "some type"
  }
  @update_attrs %{
    display_colour: "some updated display_colour",
    display_icon: :cog_6_tooth,
    frequency: 43,
    frequency_type: :days,
    subtitle: "some updated subtitle",
    title: "some updated title",
    type: "some updated type"
  }
  @invalid_attrs %{
    display_colour: nil,
    display_icon: nil,
    frequency: nil,
    frequency_type: nil,
    subtitle: nil,
    title: nil,
    type: nil
  }

  defp create_task(_) do
    task = insert(:task)
    %{task: task}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all tasks", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, ~p"/tasks")

      assert html =~ "Listing Tasks"
      assert html =~ task.title
    end

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, ~p"/tasks/new")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tasks")

      assert html =~ "Task created successfully"
      assert html =~ "some title"
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, ~p"/tasks/#{task}/edit")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tasks")

      assert html =~ "Task updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    test "displays task", %{conn: conn, task: task} do
      {:ok, _show_live, html} = live(conn, ~p"/tasks/#{task}")

      assert html =~ "Show Task"
      assert html =~ task.display_colour
    end

    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = live(conn, ~p"/tasks/#{task}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, ~p"/tasks/#{task}/show/edit")

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/tasks/#{task}")

      assert html =~ "Task updated successfully"
      assert html =~ "some updated display_colour"
    end
  end
end
