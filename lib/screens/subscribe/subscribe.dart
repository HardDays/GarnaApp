import 'package:flutter/material.dart';
import 'package:garna/global/constants.dart';
import 'package:garna/global/utilities/garna_app_icons.dart';
import 'package:garna/global/widgets/custom_icon_button.dart';
import 'package:garna/global/widgets/custom_material_button.dart';

class SubscribeScreen extends StatelessWidget {
  final bool isAvailableTrial;
  const SubscribeScreen({
    Key key,
    this.isAvailableTrial = false,
  }) : super(key: key);

  static const String id = '/subscribe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Image.asset(
              'assets/images/background/background.png',
              fit: BoxFit.cover,
              // colorBlendMode: BlendMode.,
              // color: Colors.black.withOpacity(0.5),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.001),
                    // Colors.black.withOpacity(0.38),
                    Colors.black.withOpacity(0.79),
                  ], 
                  begin: Alignment.topCenter, 
                  end: Alignment.bottomCenter
                ),
              ),
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(
                  flex: 6,
                ),
                Padding(
                  padding: Constants.standardPadding,
                  child: Text(
                    'Неограниченный доступ\n к стильным фильтрам \n'
                    'для твоих фото и видео ',
                    style: TextStyle(
                        color: Theme.of(context).primaryColorLight,
                        fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                ),
                // const Spacer(),
                Padding(
                  padding: Constants.standardPadding,
                  child: Text(
                    'Без рекламы и встроенных покупок',
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColorLight),
                  ),
                ),
                const Spacer(
                  flex: 6,
                ),
                CustomMaterialButton(
                  infiniteWidth: true,
                  margin: const EdgeInsets.symmetric(horizontal: 52),
                  child: Text(
                    isAvailableTrial ? 'Пробная версия' : 'Оформить подписку',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {},
                ),
                Padding(
                  padding: Constants.standardPadding,
                  child: Text(
                    isAvailableTrial
                        ? 'Бесплатно три дня, затем 199 ₽ / месяц'
                        : 'Стоимость подписки 199 ₽ / месяц',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      color: Constants.colorLightGrey,
                      fontSize: 12,
                    ),
                  ),
                ),
                // const Spacer(),
                Padding(
                  padding: Constants.standardPadding,
                  child: InkWell(
                    onTap: () {},
                    child: const Text(
                      'Восстановить покупку',
                      style: TextStyle(
                        color: Constants.colorLightGrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: Constants.standardPadding,
                  child: InkWell(
                    onTap: () {},
                    child: const Text(
                      'Политика конфиденциальности',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {},
                    child: const Text(
                      'Условия пользования',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            isAvailableTrial
                ? Positioned(
                    // top: Constants.standardPaddingDouble,
                    top: 0,
                    left: 0,
                    child: CustomIconButton(
                      icon: GarnaAppIcons.cancel,
                      iconColor: Theme.of(context).primaryColorLight,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
