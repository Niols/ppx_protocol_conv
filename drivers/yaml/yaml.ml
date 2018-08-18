module Yaml = Global.Yaml
module Driver : Ppx_protocol_driver.Driver with type t = Yaml.value = struct
  type t = Yaml.value
  let to_string_hum t =
    let b = Buffer.create 64 in
    Yaml.pp (Format.formatter_of_buffer b ) t;
    Buffer.contents b

  let of_list l = `A l
  let to_list = function `A l -> l | _ -> failwith "List expected"
  let is_list = function `A _ -> true | _ -> false

  let of_alist a = `O a
  let to_alist = function `O a -> a
                        | _ -> failwith "Object expected"
  let is_alist = function `O _ -> true | _ -> false

  let of_int i = `Float (float_of_int i)
  let to_int = function
    | `Float f -> begin match int_of_float f with
        | n when Float.abs (float_of_int n -. f ) < 0.000001 -> n
        | _ -> failwith "Int expected"
      end
    | _ -> failwith "Int expected"

  let of_int32 i = Int32.to_int i |> of_int
  let to_int32 t = to_int t |> Int32.of_int

  let of_int64 i = Int64.to_int i |> of_int
  let to_int64 t = to_int t |> Int64.of_int

  let of_float f = `Float f
  let to_float = function `Float f -> f
                        | _ -> failwith "Float expected"

  let of_string s = `String s
  let to_string = function `String s -> s
                         | _ -> failwith "String expected"
  let is_string = function `String _ -> true | _ -> false

  let of_bool b = `Bool b
  let to_bool = function `Bool b -> b
                       | _ -> failwith "Bool expected"

  let null = `Null
  let is_null = function `Null -> true | _ -> false
end

include Ppx_protocol_driver.Make(Driver)

let of_yaml t = t
let to_yaml t = t
