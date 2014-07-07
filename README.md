wbutils
=======

A collection of small Erlang utility functions used at Wildbit

```erlang
%% UNIX time
epoch_now_utc/0

%% MD5 digest as a HEX string
md5_hex/1

%% Mustache template evaluation
template/2
binary_template/2

%% Directory operations
create_tmp_dir/1
delete_dir/1
with_temp_dir/2
```
