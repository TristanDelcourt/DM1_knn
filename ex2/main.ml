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
  
(*trouve le plus proche voisin de v dans t*)
let rec unpp_voisin (t: kd_tree) (v: vector) = match t with
  | Vide -> [||]
  | Node(dim, v_sep, g, d) ->
      if v.(dim) <= v_sep.(dim) then begin
        let vg = unpp_voisin g v in
        if vg != [||] && dist vg v <= v_sep.(dim) -. v.(dim) then
          vg
        else begin
          let vd = unpp_voisin d v in
          trouver_meilleur_candidats [|v_sep; vg; vd|] v
        end
      end
      else begin
        let vd = unpp_voisin d v in
        if vd != [||] && dist vd v <= v.(dim) -. v_sep.(dim) then
          vd
        else begin
          let vg = unpp_voisin g v in
          trouver_meilleur_candidats [|v_sep; vg; vd|] v
        end
      end

let print_vector_list (l: vector list) =
  List.iter (fun x -> Printf.printf "(%f, %f)\n" x.(0) x.(1)) l

(* insert x dans l tel que l est de taille inferieure a k et l décroissante par ordre de distance a v*)
let insert_sorted (v: vector) (x: vector) (l: vector list) (k: int) : vector list =
  if dist x v > dist (List.hd l) v && List.length l = k then
    l
  else

  let rec aux acc1 acc2 = match acc2 with
    | [] -> 
      if List.length l = k then
        List.tl (List.rev (x::acc1))
      else
        (List.rev (x::acc1))
    | y::q -> 
    if dist x v > dist y v then
      if List.length l = k then
        List.tl (List.rev (x::acc1)) @ acc2
      else
        (List.rev (x::acc1)) @ acc2
    else
      aux (y::acc1) q

  in
  aux [] l

(* trouve les k plus proches candidats de v parmis v1, les vecteurs de l1 et de l2*)
let trouver_meilleur_candidats_k (v: vector) (v1: vector) (l1: vector list) (l2: vector list) (k: int) =
  if k = 0 then []
  else begin
  let p = List.fold_left (fun acc x -> insert_sorted v x acc k) [v1] l1 in
  let q = List.fold_left (fun acc x -> insert_sorted v x acc k) p l2 in
  print_vector_list q;
  Printf.printf "%d : %d : %d\n---\n" (1 + List.length l1 + List.length l2) k (List.length q);
  q
  end

(* trouve les k plus proches voisins de v dans l'arbre t*)
let rec pp_voisin_k (t: kd_tree) (v: vector) (k: int) = 
  if k = 0 then []
  else begin
  match t with
  | Vide -> []
  | Node(dim, v_sep, g, d) ->
      if v.(dim) <= v_sep.(dim) then begin
        let vg = pp_voisin_k g v k in
        let s, sur, pas_sur = List.fold_left (fun acc x -> 
          let s, sur, pas_sur = acc in
          if dist x v <= v_sep.(dim) -. v.(dim) then ((s+1), (x::sur), pas_sur)
          else (s, sur, (x::pas_sur))) (0, [], []) vg in
        let vd = pp_voisin_k d v (k-s) in
        (sur @ (trouver_meilleur_candidats_k v v_sep pas_sur vd (k-s)))
      end
      else begin
      let vd = pp_voisin_k d v k in
      let s, sur, pas_sur = List.fold_left (fun acc x -> 
        let s, sur, pas_sur = acc in
        if dist x v <= v.(dim) -. v_sep.(dim) then ((s+1), (x::sur), pas_sur)
        else (s, sur, (x::pas_sur))) (0, [], []) vd in
      let vg = pp_voisin_k g v (k-s) in
      (sur @ (trouver_meilleur_candidats_k v v_sep pas_sur vg (k-s)))
    end
  end

let colour_voisins (voisins: vector list) (v: vector) =
  Graphics.set_color Graphics.blue;
  List.iter (fun x ->
    Graphics.fill_circle (to_x x.(0)) (to_y x.(1)) 5
  ) voisins;
  let max = List.fold_left (fun acc x -> if dist x v > acc then dist x v else acc) (dist (List.hd voisins) v) voisins in
  Graphics.draw_circle (to_x v.(0)) (to_y v.(1)) (int_of_float (float_of_int cx *. max))

let main_exemple () =
  Random.self_init ();
  let nb_points = 500 in
  let t = genere_jeu_donnes nb_points in
  let kd_tree = build_tree t 2 in         (* TODO : remplacer ici par votre fonction de génération d'un arbre k dimensionel *)
  Graphics.open_graph " 1000x1000";
  draw_kd_tree kd_tree;
  let v = Array.init 2 (fun _ -> Random.float 1.) in
  let voisins = pp_voisin_k kd_tree v 5 in
  Printf.printf "Nb voisins : %d\n" (List.length voisins);
  print_vector_list voisins;

  Graphics.set_color Graphics.red;
  Graphics.fill_circle (to_x v.(0)) (to_y v.(1)) 5;
  (*Graphics.fill_circle (to_x voisin.(0)) (to_y voisin.(1)) 5;*)
  colour_voisins voisins v;
  Graphics.set_color Graphics.green;
  (*Graphics.draw_circle (to_x v.(0)) (to_y v.(1)) (int_of_float (float_of_int cx *.  (dist v voisin)));*)
  Graphics.loop_at_exit [] (fun _ -> ())


let () = main_exemple ()
