open !Base
open !Protocol_conv_json
open !Protocol_conv_xml

exception Default
let t_to_json _ = raise Default
let t_of_json _ = raise Default

module Both = struct
  type t = int [@@deriving protocol ~driver:(module Json)]
   let () =
    match t_to_json 3 with
    | _ -> ()
    | exception Default -> failwith "t_to_json not present"

  let () =
    match t_of_json (`Int 3) with
    | _ -> ()
    | exception Default -> failwith "t_to_json not present"
end

module Serialize = struct
  type t = int [@@deriving to_protocol ~driver:(module Json)]
   let () =
    match t_to_json 3 with
    | _ -> ()
    | exception Default -> failwith "t_to_json not present"

  let () =
    match t_of_json (`Int 3) with
    | _ -> failwith "t_of_json actually implemented"
    | exception Default -> ()
end

module Deserialize = struct
  type t = int [@@deriving of_protocol ~driver:(module Json)]
   let () =
    match t_to_json 3 with
    | _ -> failwith "t_to_json actually implemented"
    | exception Default -> ()

  let () =
    match t_of_json (`Int 3) with
    | _ -> ()
    | exception Default -> failwith "t_of_json not present"
end
