# XXChildScrollController
多子控制器左右滑动切换，支持导航栏titleView跟随渐变。

# 使用方法
组件提供一个基类<code>XXChildScrollController</code>，使用时继承该基类（例如子类为XXTempChildScrollController），重写两个方法：
<pre>

- (void)scrollControllerWillEndChange; //滑动即将结束处理事件，此时nowIndex未改变（子类重写，对即将消失的页面进行业务处理）

- (void)scrollControllerDidEndChange; //滑动结束后处理事件（子类重写，对当前显示的页面进行业务处理）

</pre>
使用很简单，一句代码搞定：
<pre>

[[XXTempChildScrollController alloc] initWithChildControllers:self.childControllers startIndex:0];
</pre>
具体效果：

![image](https://github.com/HJTXX/XXChildScrollController/blob/master/Source/temp.gif)

# 最后
如果在使用中遇到任何问题或者建议，欢迎issues，我会尽快处理，如果帮助到你，你懂的😏。
