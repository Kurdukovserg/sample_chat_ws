import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../../presentation/authentication/login_page.dart';
import '../../presentation/home/home_page.dart';

part 'router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter();

  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        path: '/',
        page: LoginRoute.page,
        initial: true,
      ),
      AutoRoute(
        path: '/home',
        page: HomeRoute.page,
      ),
    ];
  }
}
