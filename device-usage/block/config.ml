open Mirage

type shellconfig = ShellConfig
let shellconfig = Type.v ShellConfig

let config_shell =
  let build _ =
    Action.run_cmd Bos.Cmd.(v "dd" % "if=/dev/zero" % "of=disk.img" % "count=100000")
  in
  let clean _ = Action.rm (Fpath.v "disk.img") in
  impl ~build ~clean "Functoria_runtime" shellconfig

let main =
  let packages = [ package "io-page"; package "duration"; package ~build:true "bos"; package ~build:true "fpath" ] in
  main
    ~packages
    ~extra_deps:[dep config_shell]
    "Unikernel.Main" (time @-> block @-> job)

let img = Key.(if_impl is_solo5 (block_of_file "storage") (block_of_file "disk.img"))

let () =
  register "block_test" [main $ default_time $ img]
