import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:matrix/matrix.dart' as link;

import '../../components/components.dart';
import '../../utils/screen.dart';
import '../../store/im.dart';
import '../../store/theme.dart';
import '../../utils/functions.dart';

class CreatePrivatePage extends StatefulWidget {
  final Function? closeModel;
  const CreatePrivatePage({Key? key, this.closeModel}) : super(key: key);

  @override
  State<CreatePrivatePage> createState() => _CreatePrivatePageState();
}

class _CreatePrivatePageState extends State<CreatePrivatePage> {
  String search = "";
  late IMProvider im;
  List<link.Profile> userList = [];
  TextEditingController id = TextEditingController();

  @override
  void initState() {
    super.initState();
    im = context.read<IMProvider>();
    id.text = "@user_id:192.168.111.109:8008";
    getList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getList() async {
    final client = im.currentState!.client;
    link.SearchUserDirectoryResponse response =
        await client.searchUserDirectory(search != "" ? "%$search" : "", limit: 10);

    setState(() {
      userList = response.results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstTheme.centerChannelBg,
      appBar: widget.closeModel == null
          ? LocalAppBar(
              title: "添加私信",
              onBack: () {
                context.pop();
              },
            ) as PreferredSizeWidget
          : ModelBar(
              title: "添加私信",
              onBack: () {
                if (widget.closeModel != null) {
                  widget.closeModel!.call();
                  return;
                }
                context.pop();
              },
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 15.w),
              Expanded(
                child: Container(
                  height: 40.w,
                  margin: EdgeInsets.only(top: 10.w, bottom: 10.w),
                  padding: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    color: ConstTheme.sidebarText.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(3.w)),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    onChanged: (v) => search = v,
                    onSubmitted: (value) => {getList()},
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    style: TextStyle(color: ConstTheme.sidebarText.withAlpha(155), fontSize: 13.w),
                    decoration: InputDecoration(
                      label: null,
                      hintText: '查找用户',
                      hintStyle: TextStyle(
                        height: 1.5,
                        color: ConstTheme.sidebarText.withAlpha(155),
                      ),
                      suffixIcon: Icon(Icons.search, size: 20.w, color: ConstTheme.sidebarText.withAlpha(155)),
                      contentPadding: const EdgeInsets.all(0),
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.w,
                width: 60.w,
                child: Center(
                  child: InkWell(
                    onTap: () {
                      getList();
                    },
                    child: Text(
                      '搜索',
                      style: TextStyle(
                        color: ConstTheme.centerChannelColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.w,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
          Divider(
            height: 5.w,
            color: ConstTheme.centerChannelColor.withOpacity(0.1),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10.w,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 15.w),
                        UserAvatar(
                          getUserShortId(userList[index].userId),
                          true,
                          40.w,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userList[index].displayName ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                color: ConstTheme.centerChannelColor.withOpacity(0.6),
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              userList[index].userId,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(
                                color: ConstTheme.centerChannelColor,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(width: 15.w),
                      ],
                    )
                  ],
                );
              },
            ),
          ),
          Divider(
            height: 5.w,
            color: ConstTheme.centerChannelColor.withOpacity(0.1),
          ),
          SizedBox(height: 8.w),
          Container(
            margin: EdgeInsets.only(left: 15.w),
            child: Text(
              "或者输入用户id开始聊天",
              style: TextStyle(color: ConstTheme.sidebarText.withAlpha(155)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 15.w),
              Expanded(
                child: Container(
                  height: 40.w,
                  margin: EdgeInsets.only(top: 10.w, bottom: 10.w),
                  padding: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    color: ConstTheme.sidebarText.withOpacity(0.1),
                    borderRadius: BorderRadius.all(Radius.circular(3.w)),
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: id,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    style: TextStyle(color: ConstTheme.sidebarText.withAlpha(155), fontSize: 13.w),
                    decoration: InputDecoration(
                      label: null,
                      hintText: '@username',
                      hintStyle: TextStyle(
                        height: 1.5,
                        color: ConstTheme.sidebarText.withAlpha(155),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      border: const OutlineInputBorder(borderSide: BorderSide.none),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.send_outlined, color: ConstTheme.sidebarText),
                        onPressed: () async {
                          final client = im.currentState!.client;
                          final result = await showFutureLoadingDialog<String>(
                            context: context,
                            future: () => client.startDirectChat("@xiaobai:xiaobai.asyou.me"),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
            ],
          ),
          SizedBox(height: 15.w),
        ],
      ),
    );
  }
}