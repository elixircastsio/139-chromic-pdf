defmodule Teacher.RecordingsTest do
  use Teacher.DataCase

  alias Teacher.Recordings

  describe "albums" do
    alias Teacher.Recordings.Album

    import Teacher.RecordingsFixtures

    @invalid_attrs %{artist: nil, summary: nil, title: nil, year: nil}

    test "list_albums/0 returns all albums" do
      album = album_fixture()
      assert Recordings.list_albums() == [album]
    end

    test "get_album!/1 returns the album with given id" do
      album = album_fixture()
      assert Recordings.get_album!(album.id) == album
    end

    test "create_album/1 with valid data creates a album" do
      valid_attrs = %{artist: "some artist", summary: "some summary", title: "some title", year: 42}

      assert {:ok, %Album{} = album} = Recordings.create_album(valid_attrs)
      assert album.artist == "some artist"
      assert album.summary == "some summary"
      assert album.title == "some title"
      assert album.year == 42
    end

    test "create_album/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recordings.create_album(@invalid_attrs)
    end

    test "update_album/2 with valid data updates the album" do
      album = album_fixture()
      update_attrs = %{artist: "some updated artist", summary: "some updated summary", title: "some updated title", year: 43}

      assert {:ok, %Album{} = album} = Recordings.update_album(album, update_attrs)
      assert album.artist == "some updated artist"
      assert album.summary == "some updated summary"
      assert album.title == "some updated title"
      assert album.year == 43
    end

    test "update_album/2 with invalid data returns error changeset" do
      album = album_fixture()
      assert {:error, %Ecto.Changeset{}} = Recordings.update_album(album, @invalid_attrs)
      assert album == Recordings.get_album!(album.id)
    end

    test "delete_album/1 deletes the album" do
      album = album_fixture()
      assert {:ok, %Album{}} = Recordings.delete_album(album)
      assert_raise Ecto.NoResultsError, fn -> Recordings.get_album!(album.id) end
    end

    test "change_album/1 returns a album changeset" do
      album = album_fixture()
      assert %Ecto.Changeset{} = Recordings.change_album(album)
    end
  end
end
