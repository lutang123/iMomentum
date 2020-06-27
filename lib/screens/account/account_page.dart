import 'package:flutter/material.dart';
import 'package:iMomentum/app/common_widgets/avatar.dart';
import 'package:iMomentum/app/common_widgets/linear_gradient_container.dart';
import 'package:iMomentum/app/common_widgets/platform_alert_dialog.dart';
import 'package:iMomentum/app/constants/constants.dart';
import 'package:iMomentum/app/services/database.dart';
import 'package:iMomentum/screens/entries/calendar_bloc.dart';
import 'package:iMomentum/app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AccountPage extends StatefulWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Provider<CalendarBloc>(
      create: (_) => CalendarBloc(database: database),
      child: AccountPage(),
    );
  }

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with TickerProviderStateMixin {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  CalendarController _calendarControllerNew;
  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    _calendarControllerNew = CalendarController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _calendarControllerNew.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.network(Constants.homePageImage, fit: BoxFit.cover),
        ContainerLinearGradient(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _confirmSignOut(context),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(130),
              child: _buildUserInfo(user),
            ),
          ),
          body: Container(),
        ),
      ],
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      children: <Widget>[
        Avatar(
          photoUrl: user.photoUrl,
          radius: 50,
        ),
        SizedBox(height: 8),
        if (user.displayName != null)
          Text(
            user.displayName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        SizedBox(height: 8),
      ],
    );
  }
}
