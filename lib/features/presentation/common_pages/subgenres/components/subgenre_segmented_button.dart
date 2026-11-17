// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../utils/extensions/build_context_ext.dart';
// import '../../../style/app.colors.dart';
// import '../../state/subgenres_cubit.dart';
// import '../../subgenres_state_enums/subgenres_state_enums.dart';
//
// ///Constants
// const double kFixedSizeSegmentedButtonWidth = 312;
// const double kSegmentedButtonBorderRadius = 12;
// const double kSegmentedButtonStrokeWidth = 1;
// const double kSegmentedButtonSelectedFontSize = 18;
// const double kSegmentedButtonNotSelectedFontSize = 15;
//
// ///Segmented button with Artist, Songs, Fans segments
// class SubgenreSegmentedButton extends StatefulWidget {
//   const SubgenreSegmentedButton({super.key});
//
//   @override
//   State<SubgenreSegmentedButton> createState() =>
//       _SubgenreSegmentedButtonState();
// }
//
// ///LikedSubgenresCubit
// LikedSubgenresCubit _getCubit(BuildContext context) => context.read();
//
// class _SubgenreSegmentedButtonState extends State<SubgenreSegmentedButton> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<LikedSubgenresCubit, LikedSubgenresState>(
//       builder: (context, state) {
//         return SegmentedButton(
//           showSelectedIcon: false,
//           style: ButtonStyle(
//             side: WidgetStatePropertyAll<BorderSide>(
//               BorderSide(
//                 width: kSegmentedButtonStrokeWidth,
//                 color: lightColorScheme.backgroundGrey,
//               ),
//             ),
//             shape: WidgetStatePropertyAll<OutlinedBorder>(
//               RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(
//                   kSegmentedButtonBorderRadius,
//                 ),
//               ),
//             ),
//
//             ///TextStyle depends on selection state
//             textStyle: WidgetStateProperty.resolveWith<TextStyle?>(
//                 (Set<WidgetState> s) {
//               if (s.contains(WidgetState.selected)) {
//                 return context.textStyle.bodySmall?.copyWith(
//                   fontWeight: FontWeight.w700,
//                   fontSize: kSegmentedButtonSelectedFontSize,
//                 );
//               }
//               return context.textStyle.bodySmall?.copyWith(
//                 fontWeight: FontWeight.w300,
//                 fontSize: kSegmentedButtonNotSelectedFontSize,
//               );
//             }),
//             fixedSize: const WidgetStatePropertyAll<Size>(
//               Size.fromWidth(
//                 kFixedSizeSegmentedButtonWidth,
//               ),
//             ),
//
//             ///Foreground Color depends on selection state
//             foregroundColor:
//                 WidgetStateProperty.resolveWith<Color>((Set<WidgetState> s) {
//               if (s.contains(WidgetState.selected)) {
//                 return lightColorScheme.fieldText;
//               }
//               return Colors.white;
//             }),
//
//             ///Background Color depends on selection state
//             backgroundColor:
//                 WidgetStateProperty.resolveWith<Color>((Set<WidgetState> s) {
//               if (s.contains(WidgetState.selected)) {
//                 return lightColorScheme.yellowLight;
//               }
//               return lightColorScheme.onPrimaryContainer;
//             }),
//           ),
//
//           ///Depending on selection calls appropriate method from LikedSubgenresCubit
//           onSelectionChanged: (selection) {
//             switch (selection.first) {
//               case ChosenTab.artists:
//                 _getCubit(context).selectArtistsTab();
//               case ChosenTab.songs:
//                 _getCubit(context).selectSongsTab();
//               case ChosenTab.fans:
//                 _getCubit(context).selectFansTab();
//             }
//           },
//           segments: ChosenTab.values
//               .map(
//                 (ChosenTab t) => ButtonSegment(
//                   value: t,
//                   label: Text(t.tabTitle),
//                 ),
//               )
//               .toList(),
//           selected: <ChosenTab>{_getCubit(context).state.chosenTab},
//         );
//       },
//     );
//   }
// }
