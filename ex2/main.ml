open Random
open Graphics

type vector = float array

let f_cmp i = fun (x:vector) (y:vector) -> x.(i) <= y.(i)

let partition t d f p cmp =
  let swap i j = 
    let tmp = t.(i) in 
    t.(i) <- t.(j);
    t.(j) <- tmp 
  in
  
  let pivot = t.(p) in
  swap p d;
  let a = ref (d+1) in
  let b = ref f in

  while !a <= !b do
    if cmp t.(!a) pivot then 
      incr a
    else begin
      swap !a !b;
      decr b
    end
  done;

  swap d (!a-1);
  !a-1

let rec selection t d f r cmp =
  if d < f then begin
    let p = Random.int (f-d+1) + d in
    let q = partition t d f p cmp in
    if r = q then
      t.(r)
    else if r < q then
      selection t d (q-1) r cmp
    else
      selection t (q+1) f r cmp
  end
  else
    t.(d)
  

type kd_tree =
  | Vide
  | Node of int * vector * kd_tree * kd_tree
    
let rec build_tree (data: vector array) (k: int) = 
  let n = Array.length data in
  let rec aux d f i = 
    if d >= f then 
      Vide
    else begin
      let v = selection data d f ((f-d)/2) (f_cmp i) in
      let ag = aux d ((f-d)/2 - 1) ((i+1) mod k) in
      let ad = aux ((f-d)/2 + 1) f ((i+1) mod k) in
      Node(i+1, v, ag, ad)
    end
  in  
  aux 0 (n-1) 0


(* GÉNÉRATION JEU TEST *)
let genere_jeu_donnes (n: int) : vector array =
  Array.init n (fun i -> Array.init 2 (fun _ -> Random.float 1.))

(* OUTILS GRAPHIQUES *)

let yellow = Graphics.rgb 210 160 4
let cx = 1000
let cy = 1000
let to_x pt = (pt *. (float_of_int cx)) |> int_of_float
let to_y pt = (pt *. (float_of_int cy)) |> int_of_float

let rec draw_kd_tree_aux (t: kd_tree) swx swy nex ney =
  match t with
  | Vide -> ()
  | Node(dim, v_sep, g, d) ->
    begin
      let dx, dy = to_x v_sep.(0), to_y v_sep.(1) in
      if dim = 0 then
        begin
          Graphics.set_color Graphics.black;
          Graphics.moveto dx swy; Graphics.lineto dx ney;
          Graphics.set_color yellow;
          Graphics.fill_circle dx dy 5;
          draw_kd_tree_aux g swx swy dx ney;
          draw_kd_tree_aux d dx swy nex ney;
        end
      else
        begin
          Graphics.set_color Graphics.black;
          Graphics.moveto swx dy; Graphics.lineto nex dy;
          Graphics.set_color yellow;
          Graphics.fill_circle dx dy 5;
          draw_kd_tree_aux g swx swy nex dy;
          draw_kd_tree_aux d swx dy nex ney;
        end;
    end

let draw_kd_tree (t: kd_tree) =
  (* Hyp : fenêtre graphique de taille cx * cy ouverte
     dessine l'arbre t
  *)
  draw_kd_tree_aux t 0 0 cx cy

let main_exemple () =
  let nb_points = 50 in
  let t = genere_jeu_donnes nb_points in
  let kd_tree = build_tree t 2 in         (* TODO : remplacer ici par votre fonction de génération d'un arbre k dimensionel *)
  Graphics.open_graph " 1000x1000";
  draw_kd_tree kd_tree;
  Graphics.loop_at_exit [] (fun _ -> ())

let () = main_exemple ()
