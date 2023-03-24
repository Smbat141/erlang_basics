#FROM erlang:latest
#WORKDIR /home/projects
#RUN wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3
#RUN rebar3 new app websocket
#COPY rebar.config websocket/rebar.config
#COPY server.erl websocket
#WORKDIR websocket
#RUN rebar3 deps
#RUN rebar3 compile
#EXPOSE 8080
#CMD erl -pa _build/default/lib/*/ebin
#CMD rebar3 run
#CMD ["rebar3", "shell"]


## GENRATE COWBOY HANDLER
#RUN make new t=cowboy.http n=hello_handler



FROM erlang:latest
WORKDIR /home/projects/websocket
RUN wget https://erlang.mk/erlang.mk
RUN make -f erlang.mk bootstrap bootstrap-rel
COPY Makefile .
COPY websocket_app.erl src/websocket_app.erl
COPY websocket_graphics_handler.erl src
COPY websocket_sup.erl src
#COPY clock1.erl src
#COPY interact1.erl src
#COPY shell1.erl src
#COPY chat1.erl src
#COPY chat2.erl src
#COPY irc.erl src
#COPY svg1.erl src
COPY svg_pad4.erl src
COPY ezwebframe_mochijson2.erl src
CMD make run
