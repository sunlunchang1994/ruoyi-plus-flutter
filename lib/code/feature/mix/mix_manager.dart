import 'mix_method_channel_handler.dart';
import 'mix_page_handler.dart';

///
/// @Author sunlunchang
/// 嵌入在原生应用上的消息盒子用于接收消息
/// 混合开发可以用到
///
class MixManager {
  MixMethodChannelHandler? _mixMethodChannelHandler;
  MixPageHandler? _mixPageHandler;

  MixMethodChannelHandler get mixMethodChannelHandler => _mixMethodChannelHandler!;

  MixPageHandler get mixPageHandler => _mixPageHandler!;

  MixManager() {
    _mixMethodChannelHandler = MixMethodChannelHandler();
    _mixMethodChannelHandler!.init();
    _mixPageHandler = MixPageHandler(_mixMethodChannelHandler!);
    _mixPageHandler!.init();
  }

}
