defmodule TeacherWeb.AlbumLiveTest do
  use TeacherWeb.ConnCase

  import Phoenix.LiveViewTest
  import Teacher.RecordingsFixtures

  @create_attrs %{artist: "some artist", summary: "some summary", title: "some title", year: 42}
  @update_attrs %{artist: "some updated artist", summary: "some updated summary", title: "some updated title", year: 43}
  @invalid_attrs %{artist: nil, summary: nil, title: nil, year: nil}

  defp create_album(_) do
    album = album_fixture()
    %{album: album}
  end

  describe "Index" do
    setup [:create_album]

    test "lists all albums", %{conn: conn, album: album} do
      {:ok, _index_live, html} = live(conn, Routes.album_index_path(conn, :index))

      assert html =~ "Listing Albums"
      assert html =~ album.artist
    end

    test "saves new album", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.album_index_path(conn, :index))

      assert index_live |> element("a", "New Album") |> render_click() =~
               "New Album"

      assert_patch(index_live, Routes.album_index_path(conn, :new))

      assert index_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#album-form", album: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.album_index_path(conn, :index))

      assert html =~ "Album created successfully"
      assert html =~ "some artist"
    end

    test "updates album in listing", %{conn: conn, album: album} do
      {:ok, index_live, _html} = live(conn, Routes.album_index_path(conn, :index))

      assert index_live |> element("#album-#{album.id} a", "Edit") |> render_click() =~
               "Edit Album"

      assert_patch(index_live, Routes.album_index_path(conn, :edit, album))

      assert index_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#album-form", album: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.album_index_path(conn, :index))

      assert html =~ "Album updated successfully"
      assert html =~ "some updated artist"
    end

    test "deletes album in listing", %{conn: conn, album: album} do
      {:ok, index_live, _html} = live(conn, Routes.album_index_path(conn, :index))

      assert index_live |> element("#album-#{album.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#album-#{album.id}")
    end
  end

  describe "Show" do
    setup [:create_album]

    test "displays album", %{conn: conn, album: album} do
      {:ok, _show_live, html} = live(conn, Routes.album_show_path(conn, :show, album))

      assert html =~ "Show Album"
      assert html =~ album.artist
    end

    test "updates album within modal", %{conn: conn, album: album} do
      {:ok, show_live, _html} = live(conn, Routes.album_show_path(conn, :show, album))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Album"

      assert_patch(show_live, Routes.album_show_path(conn, :edit, album))

      assert show_live
             |> form("#album-form", album: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#album-form", album: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.album_show_path(conn, :show, album))

      assert html =~ "Album updated successfully"
      assert html =~ "some updated artist"
    end
  end
end
