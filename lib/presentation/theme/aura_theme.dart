import 'package:flutter/material.dart';

/// Colores de Aura (modo claro).
abstract final class AuraColors {
  static const primary = Color(0xFF3A6F8F);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFDDE9F1);
  static const onPrimaryContainer = Color(0xFF173B52);

  /// Punto junto a «Aura». Decorativo, nunca para texto.
  static const accent = Color(0xFF4F86A8);

  static const background = Color(0xFFF6F2EB);
  static const card = Color(0xFFFFFEFB);
  static const completedCard = Color(0xFFEFEAE2);
  static const track = Color(0xFFECE6DC);

  static const text = Color(0xFF24211E);
  static const textSecondary = Color(0xFF6B645C);
  static const outline = Color(0xFF8C847A);
  static const error = Color(0xFFB3412E);
  static const snackbarText = Color(0xFFF4EFE7);

  static const _shadow = Color(0xFF2B2825);

  /// Sombra muy difusa de las tarjetas pendientes.
  static final cardShadow = [
    BoxShadow(
      color: _shadow.withValues(alpha: 0.04),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: _shadow.withValues(alpha: 0.06),
      offset: const Offset(0, 6),
      blurRadius: 20,
    ),
  ];

  /// Sombra del filtro seleccionado.
  static final segmentShadow = [
    BoxShadow(
      color: _shadow.withValues(alpha: 0.08),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: _shadow.withValues(alpha: 0.06),
      offset: const Offset(0, 2),
      blurRadius: 8,
    ),
  ];
}

abstract final class AuraTheme {
  static ThemeData light() {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AuraColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AuraColors.primary,
          onPrimary: AuraColors.onPrimary,
          primaryContainer: AuraColors.primaryContainer,
          onPrimaryContainer: AuraColors.onPrimaryContainer,
          surface: AuraColors.background,
          onSurface: AuraColors.text,
          onSurfaceVariant: AuraColors.textSecondary,
          surfaceContainerLowest: AuraColors.card,
          surfaceContainerLow: AuraColors.card,
          surfaceContainer: AuraColors.completedCard,
          surfaceContainerHigh: AuraColors.track,
          outline: AuraColors.outline,
          error: AuraColors.error,
          inverseSurface: AuraColors.text,
          onInverseSurface: AuraColors.snackbarText,
          scrim: AuraColors.text,
          surfaceTint: Colors.transparent,
        );

    final textTheme = _textTheme(colorScheme);

    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: 'Figtree',
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleSpacing: 24,
        toolbarHeight: 80,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.displaySmall,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: const CircleBorder(),
        side: BorderSide(color: colorScheme.outline, width: 2),
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colorScheme.primary
              : Colors.transparent,
        ),
        checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: 3,
        menuPadding: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: textTheme.bodyLarge,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        elevation: 6,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        barrierColor: colorScheme.scrim.withValues(alpha: 0.3),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
        labelStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (states) => textTheme.labelSmall!.copyWith(
            color: states.contains(WidgetState.error)
                ? colorScheme.error
                : colorScheme.primary,
          ),
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colorScheme.error),
        border: _fieldBorder(Colors.transparent),
        enabledBorder: _fieldBorder(Colors.transparent),
        focusedBorder: _fieldBorder(colorScheme.primary),
        errorBorder: _fieldBorder(colorScheme.error),
        focusedErrorBorder: _fieldBorder(colorScheme.error),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: const StadiumBorder(),
          textStyle: textTheme.labelLarge,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 3,
        highlightElevation: 4,
        shape: const StadiumBorder(),
        extendedTextStyle: textTheme.labelLarge,
        extendedPadding: const EdgeInsetsDirectional.fromSTEB(20, 0, 26, 0),
        extendedIconLabelSpacing: 8,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onInverseSurface,
          fontWeight: FontWeight.w500,
          height: 20 / 15,
        ),
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
      ),
    );
  }

  static InputBorder _fieldBorder(Color color) {
    return _FilledFieldBorder(
      borderSide: color == Colors.transparent
          ? BorderSide.none
          : BorderSide(color: color, width: 2),
    );
  }

  /// Tamaño / interlineado en px del diseño; `height` es la proporción.
  static TextTheme _textTheme(ColorScheme colors) {
    TextStyle style(
      double size,
      double lineHeight,
      FontWeight weight, {
      double letterSpacingEm = 0,
      Color? color,
    }) {
      return TextStyle(
        fontFamily: 'Figtree',
        fontSize: size,
        height: lineHeight / size,
        fontWeight: weight,
        letterSpacing: letterSpacingEm * size,
        color: color ?? colors.onSurface,
      );
    }

    return TextTheme(
      displaySmall: style(40, 44, FontWeight.w800, letterSpacingEm: -0.035),
      headlineSmall: style(24, 30, FontWeight.w700, letterSpacingEm: -0.02),
      titleLarge: style(22, 28, FontWeight.w700, letterSpacingEm: -0.015),
      bodyLarge: style(16, 24, FontWeight.w400),
      bodyMedium: style(15, 22, FontWeight.w400),
      bodySmall: style(13, 18, FontWeight.w500),
      labelLarge: style(16, 20, FontWeight.w600),
      labelMedium: style(14, 20, FontWeight.w500),
      labelSmall: style(12, 16, FontWeight.w600),
    );
  }
}

/// Borde redondeado de los campos rellenos.
///
/// `OutlineInputBorder` coloca la etiqueta flotante en un hueco del borde; el
/// diseño la quiere dentro del campo, así que este borde se declara como no
/// "outline" y solo dibuja el contorno cuando el campo tiene foco o error.
class _FilledFieldBorder extends InputBorder {
  const _FilledFieldBorder({super.borderSide = BorderSide.none});

  static const _radius = BorderRadius.all(Radius.circular(16));

  @override
  bool get isOutline => false;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(borderSide.width);

  @override
  _FilledFieldBorder copyWith({BorderSide? borderSide}) {
    return _FilledFieldBorder(borderSide: borderSide ?? this.borderSide);
  }

  @override
  _FilledFieldBorder scale(double t) {
    return _FilledFieldBorder(borderSide: borderSide.scale(t));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(_radius.toRRect(rect).deflate(borderSide.width));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(_radius.toRRect(rect));
  }

  @override
  void paintInterior(
    Canvas canvas,
    Rect rect,
    Paint paint, {
    TextDirection? textDirection,
  }) {
    canvas.drawRRect(_radius.toRRect(rect), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0,
    double gapPercentage = 0,
    TextDirection? textDirection,
  }) {
    if (borderSide.style == BorderStyle.none) return;
    final rrect = _radius.toRRect(rect).deflate(borderSide.width / 2);
    canvas.drawRRect(rrect, borderSide.toPaint());
  }

  @override
  bool operator ==(Object other) =>
      other is _FilledFieldBorder && other.borderSide == borderSide;

  @override
  int get hashCode => borderSide.hashCode;
}
