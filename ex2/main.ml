type vector = float array

let dist (x: vector) (y: vector) =
  let n = Array.length x in
  let res = ref 0. in
  for i = 0 to n-1 do
    res := !res +. (x.(i) -. y.(i))**2.
  done;
  sqrt !res

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
    if d <= f then begin
      let centre = ((f+d)/2) in
      let v = selection data d f centre (f_cmp i) in
      let ag = aux d (centre - 1) ((i+1) mod k) in
      let ad = aux (centre + 1) f ((i+1) mod k) in
      Node(i, v, ag, ad)
    end
    else Vide
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

let trouver_meilleur_candidats (l: vector array) (v: vector) = 
  (*Hypothèse l.(0) != [||]*)
  Array.fold_left (fun acc x -> 
    if x == [||] then acc
    else if dist x v < dist acc v then x
    else acc
  ) (l.(0)) l
  
let rec pp_voisin (t: kd_tree) (v: vector) (k: int) = match t with
  | Vide -> [||]
  | Node(dim, v_sep, g, d) ->
      if v.(dim) <= v_sep.(dim) then begin
        let vg = pp_voisin g v k in
        if vg != [||] && dist vg v <= v_sep.(dim) -. v.(dim) then
          vg
        else begin
          let vd = pp_voisin d v k in
          trouver_meilleur_candidats [|v_sep; vg; vd|] v
        end
      end
      else begin
        let vd = pp_voisin d v k in
        if vd != [||] && dist vd v <= v.(dim) -. v_sep.(dim) then
          vd
        else begin
          let vg = pp_voisin g v k in
          trouver_meilleur_candidats [|v_sep; vg; vd|] v
        end
      end


let rec pp_voisin_k (t: kd_tree) (v: vector) (k: int) = 
  if k = 0 then [[||]]
  else match t with
  | Vide -> [[||]]
  | Node(dim, v_sep, g, d) ->
      if v.(dim) <= v_sep.(dim) then begin
        let vg = pp_voisin g v k in
        let s, sur, pas_sur = Array.fold_left (fun acc x -> 
          if x == [||] then acc else
          let s, sur, pas_sur = acc in
          if dist x v < v_sep.(dim) -. v.(dim) then ((s+1), (x::sur), pas_sur)
          else (s, sur, (x::pas_sur))) (0, [], []) vg in
        let vd = pp_voisin d v (k-s) in
        le
        sur 
      end
      else begin
      let vd = pp_voisin g v k in
      let s = Array.fold_left (fun acc x -> 
        if x == [||] then acc
        else if dist x v < v.(dim) -. v_sep.(dim) then (acc+1)
        else acc) 0 vd in
      let vg = pp_voisin g v (k-s) in
      trouver_meilleur_candidats_k (Array.append (Array.append vd vg) v_sep) v k
    end


let main_exemple () =
  Random.self_init ();
  let nb_points = 50 in
  let t = genere_jeu_donnes nb_points in
  let kd_tree = build_tree t 2 in         (* TODO : remplacer ici par votre fonction de génération d'un arbre k dimensionel *)
  Graphics.open_graph " 1000x1000";
  draw_kd_tree kd_tree;
  let v = Array.init 2 (fun _ -> Random.float 1.) in
  let voisin = pp_voisin kd_tree v 1 in
  Graphics.set_color Graphics.red;
  Graphics.fill_circle (to_x v.(0)) (to_y v.(1)) 5;
  Graphics.set_color Graphics.blue;
  Graphics.fill_circle (to_x voisin.(0)) (to_y voisin.(1)) 5;
  Graphics.set_color Graphics.green;
  Graphics.draw_circle (to_x v.(0)) (to_y v.(1)) (int_of_float (float_of_int cx *.  (dist v voisin)));
  Graphics.loop_at_exit [] (fun _ -> ())


let () = main_exemple ()
