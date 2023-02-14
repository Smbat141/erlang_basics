-module(migration).
-export([dist_init/0]).

dist_init() ->
    mnesia:create_table(employee,
                         [{ram_copies, ['smb@172.0.0.3', 'eva@172.0.0.4']},
                          {attributes, record_info(fields, employee)}]),
    mnesia:create_table(dept,
                         [{ram_copies, ['smb@172.0.0.3', 'eva@172.0.0.4']},
                          {attributes, record_info(fields, dept)}]),
    mnesia:create_table(project,
                         [{ram_copies, ['smb@172.0.0.3', 'eva@172.0.0.4']},
                          {attributes, record_info(fields, project)}]),
    mnesia:create_table(manager, [{type, bag},
                                  {ram_copies, ['smb@172.0.0.3', 'eva@172.0.0.4']},
                                  {attributes, record_info(fields, manager)}]),
    mnesia:create_table(at_dep,
                         [{ram_copies, ['smb@172.0.0.3', 'eva@172.0.0.4']},
                          {attributes, record_info(fields, at_dep)}]),
    mnesia:create_table(in_proj,
                        [{type, bag},
                         {ram_copies, ['smb@172.0.0.3', 'eva@172.0.0.4']},
                         {attributes, record_info(fields, in_proj)}]).