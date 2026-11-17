import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/cubit/subgenres_page_cubit.dart';
import 'package:kingfishertom/features/presentation/common_pages/subgenres/enums/genres_enum.dart';
import 'package:kingfishertom/features/presentation/resources/style/app.colors.dart';
import 'package:kingfishertom/features/utils/extensions/build_context_ext.dart';

const double _kIconSize = 16;
const double _kFontSize = 14;
const double _kTextPadding = 8;
const double _kButtonStyleDataHeight = 44;
const double _kButtonStyleDataPaddingLeft = 14;
const double _kButtonStyleDataPaddingRight = 14;
const double _kButtonStyleDataBorderRadius = 30;
const double _kIconStyleDataIconSize = 20;
const double _kDropdownStyleDataMaxHeight = 200;
const double _kDropdownStyleDataMaxWidth = 200;
const double _kDropdownStyleDataBorderRadius = 16;
const double _kMenuItemStyleDataHeight = 40;
const double _kMenuItemStyleDataPaddingLeft = 14;
const double _kMenuItemStyleDataPaddingRight = 14;

class SubgenreDropDownMenuResource extends StatelessWidget {
  const SubgenreDropDownMenuResource({required this.chosenResource, super.key});

  final ChosenResource chosenResource;

  SubgenrePageCubit _getCubit(BuildContext context) => context.read();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<ChosenResource>(
        items: ChosenResource.values
            .map(
              (ChosenResource item) => DropdownMenuItem<ChosenResource>(
                value: item,
                child: Row(
                  children: <Widget>[
                    if (chosenResource == item)
                      Icon(
                        Icons.check_circle_outline,
                        size: _kIconSize,
                        color: lightColorScheme.iconGrey,
                      ),
                    SizedBox(
                      width: chosenResource == item ? 10 : 26,
                    ),
                    Text(
                      item == ChosenResource.myLiked
                          ? context.i10n.myLiked
                          : context.i10n.globalCharts,
                      style: TextStyle(
                        fontSize: _kFontSize,
                        fontWeight: FontWeight.bold,
                        color: chosenResource == item
                            ? lightColorScheme.yellowLight
                            : lightColorScheme.surface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        value: chosenResource,
        onChanged: (ChosenResource? value) async {
          await _getCubit(context).selectResource(value);
        },
        selectedItemBuilder: (BuildContext context) {
          return ChosenResource.values.map((ChosenResource item) {
            return Padding(
              padding: const EdgeInsets.all(_kTextPadding),
              child: Text(
                item == ChosenResource.myLiked
                    ? context.i10n.myLiked.toUpperCase()
                    : context.i10n.globalCharts.toUpperCase(),
                style: TextStyle(
                  fontSize: _kFontSize,
                  fontWeight: FontWeight.bold,
                  color: lightColorScheme.surface, // Fixed color for the button
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList();
        },
        buttonStyleData: ButtonStyleData(
          height: _kButtonStyleDataHeight,
          padding: const EdgeInsets.only(
            left: _kButtonStyleDataPaddingLeft,
            right: _kButtonStyleDataPaddingRight,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              _kButtonStyleDataBorderRadius,
            ),
            border: Border.all(
              color: Colors.black26,
            ),
            color: lightColorScheme.onSurface,
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(
            Icons.keyboard_arrow_down,
          ),
          iconSize: _kIconStyleDataIconSize,
          iconEnabledColor: lightColorScheme.surface,
          iconDisabledColor: lightColorScheme.surface,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: _kDropdownStyleDataMaxHeight,
          width: _kDropdownStyleDataMaxWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              _kDropdownStyleDataBorderRadius,
            ),
            color: lightColorScheme.onSurface,
          ),
          offset: const Offset(0, -10),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: _kMenuItemStyleDataHeight,
          padding: EdgeInsets.only(
            left: _kMenuItemStyleDataPaddingLeft,
            right: _kMenuItemStyleDataPaddingRight,
          ),
        ),
      ),
    );
  }
}
