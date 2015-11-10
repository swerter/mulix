defmodule MulixTest do
  use ExUnit.Case
  doctest Mulix

  setup_all do
    emails_path = "test/data/test.com/aaa/"
    db_path = "test/data/mu/test.com/aaa"
    File.rm_rf!(db_path)
    Mulix.mu_init(emails_path, db_path)
    # on_exit fn -> File.rm_rf!(db_path) end
    :ok
  end


  test "searches for a string" do
    linkdir_path = "test/data/test.com/aaa/search"
    db_path = "test/data/mu/test.com/aaa"
    Mulix.find(db_path, linkdir_path, "tgv")
    assert {:ok, ["2645454250_1443716368_0.10854.brumbrum,U=605,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,"]} == File.ls(Path.join(linkdir_path, "cur"))
  end


  test "searches for a string not present in indexed emails" do
    linkdir_path = "test/data/test.com/aaa/search"
    db_path = "test/data/mu/test.com/aaa"
    Mulix.find(db_path, linkdir_path, "stringnottobefound")
    assert {:ok, []} == File.ls(Path.join(linkdir_path, "cur"))
  end


  test "searches for all" do
    linkdir_path = "test/data/test.com/aaa/search"
    db_path = "test/data/mu/test.com/aaa"
    Mulix.find(db_path, linkdir_path, "")
    assert {:ok,
            ["2645454250_1443716368_0.10854.brumbrum,U=605,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,",
             "425337765_1443716412_0.10854.brumbrum,U=664,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,",
             "2752835819_1443716379_0.10854.brumbrum,U=622,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,"]}
    == File.ls(Path.join(linkdir_path, "cur"))
    assert {:ok,
            ["1418404134_1444073250_1.24235.brumbrum,U=1098,FMD5=7e33429f656f1e6e9d79b29c3f82c57e:2,S"]}
    == File.ls(Path.join(linkdir_path, "new"))
  end


  test "contacts" do
    emails_path = "./test/data/test.com/aaa/"
    db_path = "./test/data/mu/test.com/aaa"
    Mulix.mu_init(emails_path, db_path)
    res = Mulix.contacts(db_path)
    assert res == [%{email: "blue@tester.ch", name: ""},
                   %{email: "news@flyerline.ch", name: "Flyerline Schweiz AG (Steffen Tomasi)"},
                   %{email: "bonsplans@newsletter.voyages-sncf.com", name: "Voyages-sncf.com"},
                   %{email: "blue@tester", name: "Hans Huber"},
                   %{email: "elixir.radar@plataformatec.com.br", name: "Elixir Radar"},
                   %{email: "alberto.olmos@avianca.com", name: "Avianca Express"}]
  end
end
