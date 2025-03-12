import 'package:json_annotation/json_annotation.dart';

part 'redis_cache_info.g.dart';

@JsonSerializable()
class RedisCacheInfo {
  RedisInfo? info;

  /// 数据库大小
  int? dbSize;

  /// 命令统计信息列表
  List<CommandStats>? commandStats;

  RedisCacheInfo({this.info, this.dbSize, this.commandStats});

  factory RedisCacheInfo.fromJson(Map<String, dynamic> json) => _$RedisCacheInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RedisCacheInfoToJson(this);
}

///Redis缓存
@JsonSerializable()
class RedisInfo {
  /// 已处理的 IO 线程读取操作数量
  String? io_threaded_reads_processed;

  /// 正在跟踪的客户端数量
  String? tracking_clients;

  /// 服务器运行的总秒数
  String? uptime_in_seconds;

  /// 集群连接数量
  String? cluster_connections;

  /// 当前写时复制（COW）的大小
  String? current_cow_size;

  /// 最大内存限制，以人类可读的格式表示
  String? maxmemory_human;

  /// 上一次 AOF 重写时的 COW 大小
  String? aof_last_cow_size;

  /// 主服务器的第二个复制 ID
  String? master_replid2;

  /// 复制积压缓冲区的内存使用量
  String? mem_replication_backlog;

  /// AOF 重写是否已安排
  String? aof_rewrite_scheduled;

  /// 总共接收的网络输入字节数
  String? total_net_input_bytes;

  /// RSS 开销比率
  String? rss_overhead_ratio;

  /// 服务器的时间频率
  String? hz;

  /// 当前 COW 大小的年龄
  String? current_cow_size_age;

  /// Redis 构建 ID
  String? redis_build_id;

  /// 上一次 AOF 后台重写的状态
  String? aof_last_bgrewrite_status;

  /// 多路复用 API
  String? multiplexing_api;

  /// 客户端最近的最大输出缓冲区大小
  String? client_recent_max_output_buffer;

  /// 分配器占用的内存
  String? allocator_resident;

  /// 内存碎片化的字节数
  String? mem_fragmentation_bytes;

  /// 当前 AOF 文件的大小
  String? aof_current_size;

  /// 复制积压缓冲区的第一个字节偏移量
  String? repl_backlog_first_byte_offset;

  /// 跟踪的总前缀数量
  String? tracking_total_prefixes;

  /// Redis 运行模式
  String? redis_mode;

  /// Redis Git 仓库是否有未提交的更改
  String? redis_git_dirty;

  /// AOF 延迟 fsync 的次数
  String? aof_delayed_fsync;

  /// 分配器的 RSS 字节数
  String? allocator_rss_bytes;

  /// 复制积压缓冲区的历史长度
  String? repl_backlog_histlen;

  /// IO 线程是否活跃
  String? io_threads_active;

  /// RSS 开销的字节数
  String? rss_overhead_bytes;

  /// 系统的总内存
  String? total_system_memory;

  /// 服务器是否正在加载数据
  String? loading;

  /// 被驱逐的键的数量
  String? evicted_keys;

  /// 最大客户端连接数
  String? maxclients;

  /// 集群是否启用
  String? cluster_enabled;

  /// Redis 版本号
  String? redis_version;

  /// 复制积压缓冲区是否活跃
  String? repl_backlog_active;

  /// AOF 缓冲区的内存使用量
  String? mem_aof_buffer;

  /// 分配器的碎片化字节数
  String? allocator_frag_bytes;

  /// 已处理的 IO 线程写入操作数量
  String? io_threaded_writes_processed;

  /// 每秒的瞬时操作数
  String? instantaneous_ops_per_sec;

  /// 已使用的内存，以人类可读的格式表示
  String? used_memory_human;

  /// 总共的错误回复数量
  String? total_error_replies;

  /// 服务器的角色（主或从）
  String? role;

  /// 最大内存限制
  String? maxmemory;

  /// Lua 脚本使用的内存
  String? used_memory_lua;

  /// 当前 RDB 后台保存操作的持续时间（秒）
  String? rdb_current_bgsave_time_sec;

  /// 服务器启动时使用的内存
  String? used_memory_startup;

  /// 主线程的系统 CPU 使用时间
  String? used_cpu_sys_main_thread;

  /// 待处理的延迟释放对象数量
  String? lazyfree_pending_objects;

  /// 待处理的 AOF 后台 fsync 操作数量
  String? aof_pending_bio_fsync;

  /// 数据集使用的内存百分比
  String? used_memory_dataset_perc;

  /// 分配器的碎片化比率
  String? allocator_frag_ratio;

  /// 系统架构位数
  String? arch_bits;

  /// 主线程的用户 CPU 使用时间
  String? used_cpu_user_main_thread;

  /// 普通客户端使用的内存
  String? mem_clients_normal;

  /// 达到过期时间上限的次数
  String? expired_time_cap_reached_count;

  /// 意外错误回复的数量
  String? unexpected_error_replies;

  /// 内存碎片化比率
  String? mem_fragmentation_ratio;

  /// 上一次 AOF 重写的持续时间（秒）
  String? aof_last_rewrite_time_sec;

  /// 主服务器的复制 ID
  String? master_replid;

  /// AOF 重写是否正在进行
  String? aof_rewrite_in_progress;

  /// Redis 配置文件的路径
  String? config_file;

  /// LRU 时钟值
  String? lru_clock;

  /// 最大内存策略
  String? maxmemory_policy;

  /// 服务器的运行 ID
  String? run_id;

  /// 最近一次 fork 操作的用时（微秒）
  String? latest_fork_usec;

  /// 跟踪的总项目数量
  String? tracking_total_items;

  /// 总共处理的命令数量
  String? total_commands_processed;

  /// 已过期的键的数量
  String? expired_keys;

  /// 错误统计信息（ERR 错误）
  String? errorstat_ERR;

  /// 已使用的内存
  String? used_memory;

  /// 模块 fork 操作是否正在进行
  String? module_fork_in_progress;

  /// AOF 缓冲区的长度
  String? aof_buffer_length;

  /// 转储有效负载的清理次数
  String? dump_payload_sanitizations;

  /// 从客户端使用的内存
  String? mem_clients_slaves;

  /// 键空间未命中的次数
  String? keyspace_misses;

  /// 服务器时间（微秒）
  String? server_time_usec;

  /// Redis 可执行文件的路径
  String? executable;

  /// 已延迟释放的对象数量
  String? lazyfreed_objects;

  /// 数据库 0 的信息
  String? db0;

  /// 已使用内存的峰值，以人类可读的格式表示
  String? used_memory_peak_human;

  /// 键空间命中的次数
  String? keyspace_hits;

  /// 上一次 RDB 保存时的 COW 大小
  String? rdb_last_cow_size;

  /// AOF 待重写的标记
  String? aof_pending_rewrite;

  /// 已使用的内存开销
  String? used_memory_overhead;

  /// 主动碎片整理命中的次数
  String? active_defrag_hits;

  /// TCP 端口号
  String? tcp_port;

  /// 服务器运行的总天数
  String? uptime_in_days;

  /// 已使用内存峰值的百分比
  String? used_memory_peak_perc;

  /// 当前保存的键的处理数量
  String? current_save_keys_processed;

  /// 被阻塞的客户端数量
  String? blocked_clients;

  /// 总共处理的读取操作数量
  String? total_reads_processed;

  /// 过期循环的 CPU 毫秒数
  String? expire_cycle_cpu_milliseconds;

  /// 错误统计信息（NOSCRIPT 错误）
  String? errorstat_NOSCRIPT;

  /// 部分同步错误的次数
  String? sync_partial_err;

  /// Lua 脚本使用的内存，以人类可读的格式表示
  String? used_memory_scripts_human;

  /// 当前 AOF 重写的持续时间（秒）
  String? aof_current_rewrite_time_sec;

  /// AOF 是否启用
  String? aof_enabled;

  /// 进程监督状态
  String? process_supervised;

  /// 主服务器的复制偏移量
  String? master_repl_offset;

  /// 数据集使用的内存
  String? used_memory_dataset;

  /// 用户 CPU 使用时间
  String? used_cpu_user;

  /// 上一次 RDB 后台保存的状态
  String? rdb_last_bgsave_status;

  /// 跟踪的总键数量
  String? tracking_total_keys;

  /// 原子变量 API
  String? atomicvar_api;

  /// 分配器的 RSS 比率
  String? allocator_rss_ratio;

  /// 客户端最近的最大输入缓冲区大小
  String? client_recent_max_input_buffer;

  /// 处于超时表中的客户端数量
  String? clients_in_timeout_table;

  /// 上一次 AOF 写入的状态
  String? aof_last_write_status;

  /// 内存分配器
  String? mem_allocator;

  /// Lua 脚本使用的内存
  String? used_memory_scripts;

  /// 已使用内存的峰值
  String? used_memory_peak;

  /// 进程 ID
  String? process_id;

  /// 主服务器故障转移状态
  String? master_failover_state;

  /// 系统 CPU 使用时间
  String? used_cpu_sys;

  /// 复制积压缓冲区的大小
  String? repl_backlog_size;

  /// 连接的从服务器数量
  String? connected_slaves;

  /// 当前保存的键的总数
  String? current_save_keys_total;

  /// GCC 版本号
  String? gcc_version;

  /// 系统的总内存，以人类可读的格式表示
  String? total_system_memory_human;

  /// 全量同步的次数
  String? sync_full;

  /// 连接的客户端数量
  String? connected_clients;

  /// 单调时钟类型
  String? monotonic_clock;

  /// 模块 fork 操作上一次的 COW 大小
  String? module_fork_last_cow_size;

  /// 总共处理的写入操作数量
  String? total_writes_processed;

  /// 分配器的活跃内存
  String? allocator_active;

  /// 总共发送的网络输出字节数
  String? total_net_output_bytes;

  /// 发布/订阅频道数量
  String? pubsub_channels;

  /// 当前 fork 操作的完成百分比
  String? current_fork_perc;

  /// 主动碎片整理键命中的次数
  String? active_defrag_key_hits;

  /// 自上次保存以来 RDB 文件的更改数量
  String? rdb_changes_since_last_save;

  /// 瞬时输入带宽（KBps）
  String? instantaneous_input_kbps;

  /// 已使用的 RSS 内存，以人类可读的格式表示
  String? used_memory_rss_human;

  /// 配置的时间频率
  String? configured_hz;

  /// 过期键的陈旧百分比
  String? expired_stale_perc;

  /// 主动碎片整理未命中的次数
  String? active_defrag_misses;

  /// 子进程的系统 CPU 使用时间
  String? used_cpu_sys_children;

  /// 缓存的脚本数量
  String? number_of_cached_scripts;

  /// 部分同步成功的次数
  String? sync_partial_ok;

  /// Lua 脚本使用的内存，以人类可读的格式表示
  String? used_memory_lua_human;

  /// 上一次 RDB 保存的时间
  String? rdb_last_save_time;

  /// 发布/订阅模式数量
  String? pubsub_patterns;

  /// 从服务器跟踪的过期键数量
  String? slave_expires_tracked_keys;

  /// Redis Git SHA1 值
  String? redis_git_sha1;

  /// 已使用的 RSS 内存
  String? used_memory_rss;

  /// 上一次 RDB 后台保存的持续时间（秒）
  String? rdb_last_bgsave_time_sec;

  /// 操作系统信息
  String? os;

  /// 未计入内存驱逐的内存
  String? mem_not_counted_for_evict;

  /// 主动碎片整理是否正在运行
  String? active_defrag_running;

  /// 被拒绝的连接数量
  String? rejected_connections;

  /// AOF 重写缓冲区的长度
  String? aof_rewrite_buffer_length;

  /// 总共的 fork 操作次数
  String? total_forks;

  /// 主动碎片整理键未命中的次数
  String? active_defrag_key_misses;

  /// 分配器已分配的内存
  String? allocator_allocated;

  /// AOF 文件的基础大小
  String? aof_base_size;

  /// 瞬时输出带宽（KBps）
  String? instantaneous_output_kbps;

  /// 第二个复制偏移量
  String? second_repl_offset;

  /// RDB 后台保存操作是否正在进行
  String? rdb_bgsave_in_progress;

  /// 子进程的用户 CPU 使用时间
  String? used_cpu_user_children;

  /// 总共接收的连接数量
  String? total_connections_received;

  /// 迁移缓存的套接字数量
  String? migrate_cached_sockets;

  RedisInfo({
    this.io_threaded_reads_processed,
    this.tracking_clients,
    this.uptime_in_seconds,
    this.cluster_connections,
    this.current_cow_size,
    this.maxmemory_human,
    this.aof_last_cow_size,
    this.master_replid2,
    this.mem_replication_backlog,
    this.aof_rewrite_scheduled,
    this.total_net_input_bytes,
    this.rss_overhead_ratio,
    this.hz,
    this.current_cow_size_age,
    this.redis_build_id,
    this.aof_last_bgrewrite_status,
    this.multiplexing_api,
    this.client_recent_max_output_buffer,
    this.allocator_resident,
    this.mem_fragmentation_bytes,
    this.aof_current_size,
    this.repl_backlog_first_byte_offset,
    this.tracking_total_prefixes,
    this.redis_mode,
    this.redis_git_dirty,
    this.aof_delayed_fsync,
    this.allocator_rss_bytes,
    this.repl_backlog_histlen,
    this.io_threads_active,
    this.rss_overhead_bytes,
    this.total_system_memory,
    this.loading,
    this.evicted_keys,
    this.maxclients,
    this.cluster_enabled,
    this.redis_version,
    this.repl_backlog_active,
    this.mem_aof_buffer,
    this.allocator_frag_bytes,
    this.io_threaded_writes_processed,
    this.instantaneous_ops_per_sec,
    this.used_memory_human,
    this.total_error_replies,
    this.role,
    this.maxmemory,
    this.used_memory_lua,
    this.rdb_current_bgsave_time_sec,
    this.used_memory_startup,
    this.used_cpu_sys_main_thread,
    this.lazyfree_pending_objects,
    this.aof_pending_bio_fsync,
    this.used_memory_dataset_perc,
    this.allocator_frag_ratio,
    this.arch_bits,
    this.used_cpu_user_main_thread,
    this.mem_clients_normal,
    this.expired_time_cap_reached_count,
    this.unexpected_error_replies,
    this.mem_fragmentation_ratio,
    this.aof_last_rewrite_time_sec,
    this.master_replid,
    this.aof_rewrite_in_progress,
    this.config_file,
    this.lru_clock,
    this.maxmemory_policy,
    this.run_id,
    this.latest_fork_usec,
    this.tracking_total_items,
    this.total_commands_processed,
    this.expired_keys,
    this.errorstat_ERR,
    this.used_memory,
    this.module_fork_in_progress,
    this.aof_buffer_length,
    this.dump_payload_sanitizations,
    this.mem_clients_slaves,
    this.keyspace_misses,
    this.server_time_usec,
    this.executable,
    this.lazyfreed_objects,
    this.db0,
    this.used_memory_peak_human,
    this.keyspace_hits,
    this.rdb_last_cow_size,
    this.aof_pending_rewrite,
    this.used_memory_overhead,
    this.active_defrag_hits,
    this.tcp_port,
    this.uptime_in_days,
    this.used_memory_peak_perc,
    this.current_save_keys_processed,
    this.blocked_clients,
    this.total_reads_processed,
    this.expire_cycle_cpu_milliseconds,
    this.errorstat_NOSCRIPT,
    this.sync_partial_err,
    this.used_memory_scripts_human,
    this.aof_current_rewrite_time_sec,
    this.aof_enabled,
    this.process_supervised,
    this.master_repl_offset,
    this.used_memory_dataset,
    this.used_cpu_user,
    this.rdb_last_bgsave_status,
    this.tracking_total_keys,
    this.atomicvar_api,
    this.allocator_rss_ratio,
    this.client_recent_max_input_buffer,
    this.clients_in_timeout_table,
    this.aof_last_write_status,
    this.mem_allocator,
    this.used_memory_scripts,
    this.used_memory_peak,
    this.process_id,
    this.master_failover_state,
    this.used_cpu_sys,
    this.repl_backlog_size,
    this.connected_slaves,
    this.current_save_keys_total,
    this.gcc_version,
    this.total_system_memory_human,
    this.sync_full,
    this.connected_clients,
    this.monotonic_clock,
    this.module_fork_last_cow_size,
    this.total_writes_processed,
    this.allocator_active,
    this.total_net_output_bytes,
    this.pubsub_channels,
    this.current_fork_perc,
    this.active_defrag_key_hits,
    this.rdb_changes_since_last_save,
    this.instantaneous_input_kbps,
    this.used_memory_rss_human,
    this.configured_hz,
    this.expired_stale_perc,
    this.active_defrag_misses,
    this.used_cpu_sys_children,
    this.number_of_cached_scripts,
    this.sync_partial_ok,
    this.used_memory_lua_human,
    this.rdb_last_save_time,
    this.pubsub_patterns,
    this.slave_expires_tracked_keys,
    this.redis_git_sha1,
    this.used_memory_rss,
    this.rdb_last_bgsave_time_sec,
    this.os,
    this.mem_not_counted_for_evict,
    this.active_defrag_running,
    this.rejected_connections,
    this.aof_rewrite_buffer_length,
    this.total_forks,
    this.active_defrag_key_misses,
    this.allocator_allocated,
    this.aof_base_size,
    this.instantaneous_output_kbps,
    this.second_repl_offset,
    this.rdb_bgsave_in_progress,
    this.used_cpu_user_children,
    this.total_connections_received,
    this.migrate_cached_sockets
  });

  factory RedisInfo.fromJson(Map<String, dynamic> json) => _$RedisInfoFromJson(json);

  Map<String, dynamic> toJson() => _$RedisInfoToJson(this);
}

///命令状态缓存
@JsonSerializable()
class CommandStats {
  /// 命令名称
  String? name;

  /// 命令执行次数
  String? value;

  CommandStats({
    this.name,
    this.value,
  });

  factory CommandStats.fromJson(Map<String, dynamic> json) => _$CommandStatsFromJson(json);

  Map<String, dynamic> toJson() => _$CommandStatsToJson(this);
}
