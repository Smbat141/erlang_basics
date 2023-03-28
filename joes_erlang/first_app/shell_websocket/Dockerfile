FROM erlang:latest
WORKDIR /home/projects/websocket
RUN wget https://erlang.mk/erlang.mk
RUN make -f erlang.mk bootstrap bootstrap-rel
COPY Makefile .
COPY websocket_app.erl src/websocket_app.erl
COPY websocket_graphics_handler.erl src
COPY websocket_sup.erl src
COPY shell1.erl src
CMD make run
