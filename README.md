# LandMark-SDM
https://github.com/RoboPai/sdm

#### OpenCv依赖的 2.4.13可以从官网下载http://opencv.org/releases.html



#### 在iOS上面运行参考

> How to compile on iOS？

>1.Copy "haar_roboman_ff_alt2.xml" & "roboman-landmark-model.bin" to your iOS Project.

    需要指定定对应的路径

```
    NSString *res = [[NSBundle mainBundle] resourcePath];
    NSString *modelBinPath = [res stringByAppendingString:@"/PCA-SDM-model_9w_stan_distclose.bin"];
    std::string mypath =  std::string([modelBinPath UTF8String]);
```

    两个文件都需要找到对应的路径,集成过程中可以使用打印log或者断点看是否成功调用c++的方法


>2.Add the OpenCV2.framework to you iOS Project, make sure you can easily read camera and show frame with OpenCV.

   
   直接从官网下载对应的版本拖入,加入需要的依赖,自行搜索细节


>3.Copy the include folder under src folder to you iOS Project source code, just copy, not anything else.
 
   
   拖入工程后,原来cpp的依赖的<a/b.hpp>的可能路径不对,替换为了 #include "b.hpp"即可,有时间再去研究下什么情况下需要添加 <a/b.h>



>4.And then #include ldmarkmodel.h in your .mm file, make sure not in .h file, use it like test_model.cpp, Compile & enjoy it.

  
>5.Make sure iOS project Build Settings option "Enable Bitcode" is "NO" (above XCode7).
  
 
 
   Xcode9 beta上面可以跑
   
   
   
   
#### 预览效果

<p>
 <img src="https://github.com/duanhai/LandMark-SDM/blob/master/t.PNG" width = "200" height = "300" alt="预览效果" align=left />
</p>
