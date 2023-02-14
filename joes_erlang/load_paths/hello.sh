docker run -it -w /home -v $(pwd):/home erlang bash -c "erl -noshell -pz /home/collab06/projects/erl/joes_erlang/load_paths/ -s hello start -s init stop"
