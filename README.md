# QmlLearningPro

# 项目列表

## 1、综合相关

### 1.算术小游戏 CrazyMath [Android] [Windows]

**创建日期**：2021.10.03 ；

**环境：** **QT5.15.2+MSVC2019、QT5.12.6+MSVC2017、Androidv7**：  

概要： 算术小游戏，主要熟悉QML和C++的混合编程、和翻译等

关键控件/库： column、SpringAnimation、transitions、State、QSetting

博客地址：https://blog.csdn.net/qq_16504163/article/details/120459571

![1-001](AReadmeQrc/1-001.gif)


---

### 2. 网络调试助手 Nettools  [Windows]

**创建日期**：20240825 ； 

概要： 自建一个网络调试助手，暂时只添加 tcp 客户端工程

博客地址：[QT Quick QML 网络助手——TCP客户端](https://blog.csdn.net/qq_16504163/article/details/141507680)

![1-002-1](AReadmeQrc/1-002-1.gif) 

---

## 2、控件相关

### 1. 平行四边形进度条 ParaProgressBar   [Android] [Windows]

**创建日期**： 2022/08/21； **20240821测试**：正常 

由15个平行四边形组成的进度条

博客地址：https://blog.csdn.net/qq_16504163/article/details/115030440

![2-001](AReadmeQrc/2-001.gif)

---

### 2. 扇形进度条 CanvasSector [Android] [Windows]

**创建日期**：20210518； **20240821测试**：正常 

CanvasSector 基于Canvas的扇形进度条

博客地址：https://blog.csdn.net/qq_16504163/article/details/116952399

![2-002](AReadmeQrc/2-002.gif)

---

### 3.目录 MenuForButton [Android] [Windows]

**创建日期**：20210518； **20240821测试**：正常 

MenuForButton 基于Button的目录

MenuForListview 基于Listview目录

MenuForRepeater 基于Repeater目录

MenuForTabBar 基于TabBar的目录

博客地址： https://blog.csdn.net/qq_16504163/article/details/109555984

![2-003-1](AReadmeQrc/2-003-1.gif)
![2-003-2](AReadmeQrc/2-003-2.gif)
![2-003-3](AReadmeQrc/2-003-3.gif)
![2-003-4](AReadmeQrc/2-003-4.gif)
![2-003-5](AReadmeQrc/2-003-5.gif)
![2-003-6](AReadmeQrc/2-003-6.gif)

---

### 4. 弹出界面Popup [Android] [Windows]

**创建日期**：2022.03.12 **20240821测试**：正常

概要： 在 QML 文件中，不论子文件有多少层，只需在根节点文件中添加 Popup 组件，都可以在界面中弹出置顶

关键控件： popup、Component、mapFromItem

博客地址：https://chuhan.blog.csdn.net/article/details/123439512

![2-004](AReadmeQrc/2-004.gif)

---

### 5. 虚拟操作杆VirtualJoystick  [Android] [Windows]

**创建日期**：2021.08.02 ； **20240821测试**：正常

概要： VirtualJoystick  增加虚拟操作杆，捕获触点，在控制物体移动。

关键控件： MultiPointTouchArea、TouchPoint、Timer

博客地址：https://blog.csdn.net/qq_16504163/article/details/119318325

![2-005](AReadmeQrc/2-005.gif)

---

### 6. TableView  [Windows]

**创建日期**：20240824； [Android] 未测试

概要： 在Qt中，如使用 QML 的 TableView 并且想要将数据与C++类进行绑定，通常会继承 QAbstractTableModel 来实现自定义的数据模型

博客地址：[QT Quick QML 实例之定制 TableView](https://blog.csdn.net/qq_16504163/article/details/141499450)

![2-006](AReadmeQrc/2-006.gif)

---

## 3、工具相关

### 1. Qt 翻译 TranslationsDemo.pro [Android] [Windows]

**创建日期**：2022.07.09 ； **20240821测试**：正常

概要： 介绍了 Qt 翻译流程，可利用 QT_TRANSLATE_NOOP 翻译 Map和函数外部的字符串

关键词：QT_TRANSLATE_NOOP、QMap<uint32_t, QString>、QSringList

关键控件： Label、Repeater

博客地址：https://chuhan.blog.csdn.net/article/details/125686784

### 2. Word 替换 WordExportQml  [Windows]

**创建日期：**2024.12.18 

**环境**：QT5.15.2+MSVC2019

概要： 用户通过 QML 界面输入键值对，选择模板文件并选择保存路径。当用户确认选择后，C++ 后端通过 QAxObject 与 Word 应用进行交互，打开模板文件并进行占位符替换，生成的新 Word 文档被保存到用户选择的位置。

关键词：QAxObject、 ListView 、ListModel 

博客地址：https://blog.csdn.net/qq_16504163/article/details/144499290

![3-002-1](AReadmeQrc/3-002-1.gif)

---


## 4、UI相关

## 5、地图类

### 1. 螺旋曲线MapFermatSpiral  [Android] [Windows]

**创建日期**：20211129；  **20240821测试**： 正常

概要： 在地图中画螺旋曲线

关键词：SpiralCurve、螺旋曲线、费马曲线

关键控件： Map、MapPolyline、TextField

博客地址：https://chuhan.blog.csdn.net/article/details/121621392

![5-001](AReadmeQrc/5-001.gif)

---

### 2. 地图中测距 MapGetdistance [Android] [Windows]

**创建日期**: 2021.11.29； **20240821测试**：正常

概要：在地图中测距

关键控件： Map

博客地址：https://blog.csdn.net/qq_16504163/article/details/109379164

---

## 6、视频类
