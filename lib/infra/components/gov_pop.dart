import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

import 'package:dtim/bridge_struct.dart';
import 'package:dtim/infra/components/components.dart';
import 'package:dtim/router.dart';
import 'package:dtim/domain/utils/screen/screen.dart';
import 'package:dtim/application/store/theme.dart';

class GovPop extends StatefulWidget {
  final Function(WithGovPs?)? closeModel;
  final MemberGroup member;
  const GovPop({Key? key, this.closeModel, required this.member}) : super(key: key);

  @override
  State<GovPop> createState() => _GovPopState();
}

class _GovPopState extends State<GovPop> {
  bool publicGroup = false;
  final SubmitData _data = SubmitData(
    type: 0,
  );
  TextEditingController pledgeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void submitAction() async {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    widget.closeModel!.call(
      WithGovPs(
        runType: _data.type,
        amount: _data.type == 1 ? 10 : 0,
        member: widget.member,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    return Scaffold(
      backgroundColor: constTheme.centerChannelBg,
      appBar: widget.closeModel == null
          ? LocalAppBar(
              title: "This operation will be executed through your org's Sudo or Gov",
              onBack: () {
                if (widget.closeModel != null) {
                  widget.closeModel!.call(null);
                  return;
                }
                context.router.pop();
              },
            ) as PreferredSizeWidget
          : ModelBar(
              title: "This operation will be executed through your org's Sudo or Gov",
              onBack: () {
                if (widget.closeModel != null) {
                  widget.closeModel!.call(null);
                  return;
                }
                context.router.pop();
              },
            ),
      body: Padding(
        padding: EdgeInsets.only(left: 15.w, right: 15.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 15.w),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    key: const Key("selectGuild"),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _data.type = 2;
                      pledgeController.text = "0";
                      setState(() {});
                    },
                    child: renderType(
                      AppIcons.zuzhi_data_organization_6,
                      "Sudo mode",
                      "Sudo mode requires administrator execution",
                      _data.type == 2,
                    ),
                  ),
                  GestureDetector(
                    key: const Key("selectProject"),
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      _data.type = 1;
                      pledgeController.text = "100";
                      setState(() {});
                    },
                    child: renderType(
                      AppIcons.xiangmu,
                      "Gov mode",
                      "Gov mode will initiate a proposal and execute it after approval",
                      _data.type == 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.w),
              TextFormField(
                key: const Key("Pledge"),
                style: TextStyle(color: constTheme.centerChannelColor),
                readOnly: true,
                controller: pledgeController,
                decoration: InputDecoration(
                  hintText: 'Proposal Pledge',
                  hintStyle: TextStyle(fontSize: 14.w, color: constTheme.centerChannelColor),
                  filled: true,
                  fillColor: constTheme.centerChannelColor.withOpacity(0.1),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.money_rounded, color: constTheme.centerChannelColor),
                ),
              ),
              // SizedBox(height: 50.w),
              const Spacer(),
              InkWell(
                key: const Key("createSpace"),
                onTap: submitAction,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 30.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: constTheme.buttonBg,
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Go to execution',
                            style: TextStyle(
                              color: constTheme.buttonColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 19.w,
                            ),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: constTheme.buttonColor,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.w),
            ],
          ),
        ),
      ),
    );
  }

  renderType(icon, title, desc, select) {
    final constTheme = Theme.of(context).extension<ExtColors>()!;
    final titleStyle = TextStyle(
      fontSize: 14.w,
      color: constTheme.centerChannelColor,
      decorationColor: constTheme.centerChannelColor,
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 13.w, left: 0.w),
          child: Icon(
            select ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: select ? constTheme.buttonBg : constTheme.centerChannelColor,
            size: 20.w,
          ),
        ),
        Container(
          width: 250.w,
          padding: EdgeInsets.all(10.w),
          // margin: EdgeInsets.only(right: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: constTheme.centerChannelColor, size: 17.w),
                  SizedBox(width: 7.w),
                  Text(title, style: titleStyle.copyWith(fontSize: 17.w)),
                ],
              ),
              SizedBox(height: 5.w),
              Text(
                desc,
                style: titleStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SubmitData {
  int type;

  SubmitData({
    required this.type,
  });
}

Future<WithGovPs?> showGovPop(MemberGroup member) async {
  var width = 600;
  var height = 300;
  return await showDialog(
    context: globalCtx(),
    useSafeArea: true,
    barrierColor: Theme.of(globalCtx()).brightness == Brightness.dark
        ? Colors.white.withOpacity(0.1)
        : Colors.black.withOpacity(0.7),
    builder: (context) {
      final media = MediaQuery.of(context);
      final bottom = media.size.height - 30.w - height.w;
      return Container(
        margin: EdgeInsets.only(
          left: (media.size.width - width.w) / 2,
          right: (media.size.width - width.w) / 2,
          top: 30.w,
          bottom: bottom > 0 ? bottom : 40.w,
        ),
        width: width.w,
        height: height.w,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8.w,
            ),
          ],
        ),
        child: GovPop(closeModel: (WithGovPs? ps) => {
          context.router.pop(ps)
        }, member:member),
      );
    },
  );
}