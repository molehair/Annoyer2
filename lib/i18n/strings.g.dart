
/*
 * Generated file. Do not edit.
 *
 * Locales: 1
 * Strings: 55 
 *
 * Built on 2022-02-25 at 13:47 UTC
 */

import 'package:flutter/widgets.dart';

const AppLocale _baseLocale = AppLocale.en;
AppLocale _currLocale = _baseLocale;

/// Supported locales, see extension methods below.
///
/// Usage:
/// - LocaleSettings.setLocale(AppLocale.en) // set locale
/// - Locale locale = AppLocale.en.flutterLocale // get flutter locale from enum
/// - if (LocaleSettings.currentLocale == AppLocale.en) // locale check
enum AppLocale {
	en, // 'en' (base locale, fallback)
}

/// Method A: Simple
///
/// No rebuild after locale change.
/// Translation happens during initialization of the widget (call of t).
///
/// Usage:
/// String a = t.someKey.anotherKey;
/// String b = t['someKey.anotherKey']; // Only for edge cases!
_StringsEn _t = _currLocale.translations;
_StringsEn get t => _t;

/// Method B: Advanced
///
/// All widgets using this method will trigger a rebuild when locale changes.
/// Use this if you have e.g. a settings page where the user can select the locale during runtime.
///
/// Step 1:
/// wrap your App with
/// TranslationProvider(
/// 	child: MyApp()
/// );
///
/// Step 2:
/// final t = Translations.of(context); // Get t variable.
/// String a = t.someKey.anotherKey; // Use t variable.
/// String b = t['someKey.anotherKey']; // Only for edge cases!
class Translations {
	Translations._(); // no constructor

	static _StringsEn of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget.translations;
	}
}

class LocaleSettings {
	LocaleSettings._(); // no constructor

	/// Uses locale of the device, fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale useDeviceLocale() {
		final locale = AppLocaleUtils.findDeviceLocale();
		return setLocale(locale);
	}

	/// Sets locale
	/// Returns the locale which has been set.
	static AppLocale setLocale(AppLocale locale) {
		_currLocale = locale;
		_t = _currLocale.translations;

		if (WidgetsBinding.instance != null) {
			// force rebuild if TranslationProvider is used
			_translationProviderKey.currentState?.setLocale(_currLocale);
		}

		return _currLocale;
	}

	/// Sets locale using string tag (e.g. en_US, de-DE, fr)
	/// Fallbacks to base locale.
	/// Returns the locale which has been set.
	static AppLocale setLocaleRaw(String rawLocale) {
		final locale = AppLocaleUtils.parse(rawLocale);
		return setLocale(locale);
	}

	/// Gets current locale.
	static AppLocale get currentLocale {
		return _currLocale;
	}

	/// Gets base locale.
	static AppLocale get baseLocale {
		return _baseLocale;
	}

	/// Gets supported locales in string format.
	static List<String> get supportedLocalesRaw {
		return AppLocale.values
			.map((locale) => locale.languageTag)
			.toList();
	}

	/// Gets supported locales (as Locale objects) with base locale sorted first.
	static List<Locale> get supportedLocales {
		return AppLocale.values
			.map((locale) => locale.flutterLocale)
			.toList();
	}

	/// Sets plural resolvers.
	/// See https://unicode-org.github.io/cldr-staging/charts/latest/supplemental/language_plural_rules.html
	/// See https://github.com/Tienisto/flutter-fast-i18n/blob/master/lib/src/model/pluralization_resolvers.dart
	/// Either specify [language], or [locale]. Locale has precedence.
	/// Rendered Resolvers: ['en']
	static void setPluralResolver({String? language, AppLocale? locale, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) {
		final List<AppLocale> locales;
		if (locale != null) {
			locales = [locale];
		} else {
			switch (language) {
				case 'en':
					locales = [AppLocale.en];
					break;
				default:
					locales = [];
			}
		}
		locales.forEach((curr) {
			switch(curr) {
				case AppLocale.en:
					_translationsEn = _StringsEn.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);
					break;
			}
		});
	}
}

/// Provides utility functions without any side effects.
class AppLocaleUtils {
	AppLocaleUtils._(); // no constructor

	/// Returns the locale of the device as the enum type.
	/// Fallbacks to base locale.
	static AppLocale findDeviceLocale() {
		final String? deviceLocale = WidgetsBinding.instance?.window.locale.toLanguageTag();
		if (deviceLocale != null) {
			final typedLocale = _selectLocale(deviceLocale);
			if (typedLocale != null) {
				return typedLocale;
			}
		}
		return _baseLocale;
	}

	/// Returns the enum type of the raw locale.
	/// Fallbacks to base locale.
	static AppLocale parse(String rawLocale) {
		return _selectLocale(rawLocale) ?? _baseLocale;
	}
}

// context enums

// interfaces generated as mixins

// translation instances

late _StringsEn _translationsEn = _StringsEn.build();

// extensions for AppLocale

extension AppLocaleExtensions on AppLocale {

	/// Gets the translation instance managed by this library.
	/// [TranslationProvider] is using this instance.
	/// The plural resolvers are set via [LocaleSettings].
	_StringsEn get translations {
		switch (this) {
			case AppLocale.en: return _translationsEn;
		}
	}

	/// Gets a new translation instance.
	/// [LocaleSettings] has no effect here.
	/// Suitable for dependency injection and unit tests.
	///
	/// Usage:
	/// final t = AppLocale.en.build(); // build
	/// String a = t.my.path; // access
	_StringsEn build({PluralResolver? cardinalResolver, PluralResolver? ordinalResolver}) {
		switch (this) {
			case AppLocale.en: return _StringsEn.build(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);
		}
	}

	String get languageTag {
		switch (this) {
			case AppLocale.en: return 'en';
		}
	}

	Locale get flutterLocale {
		switch (this) {
			case AppLocale.en: return const Locale.fromSubtags(languageCode: 'en');
		}
	}
}

extension StringAppLocaleExtensions on String {
	AppLocale? toAppLocale() {
		switch (this) {
			case 'en': return AppLocale.en;
			default: return null;
		}
	}
}

// wrappers

GlobalKey<_TranslationProviderState> _translationProviderKey = GlobalKey<_TranslationProviderState>();

class TranslationProvider extends StatefulWidget {
	TranslationProvider({required this.child}) : super(key: _translationProviderKey);

	final Widget child;

	@override
	_TranslationProviderState createState() => _TranslationProviderState();

	static _InheritedLocaleData of(BuildContext context) {
		final inheritedWidget = context.dependOnInheritedWidgetOfExactType<_InheritedLocaleData>();
		if (inheritedWidget == null) {
			throw 'Please wrap your app with "TranslationProvider".';
		}
		return inheritedWidget;
	}
}

class _TranslationProviderState extends State<TranslationProvider> {
	AppLocale locale = _currLocale;

	void setLocale(AppLocale newLocale) {
		setState(() {
			locale = newLocale;
		});
	}

	@override
	Widget build(BuildContext context) {
		return _InheritedLocaleData(
			locale: locale,
			child: widget.child,
		);
	}
}

class _InheritedLocaleData extends InheritedWidget {
	final AppLocale locale;
	Locale get flutterLocale => locale.flutterLocale; // shortcut
	final _StringsEn translations; // store translations to avoid switch call

	_InheritedLocaleData({required this.locale, required Widget child})
		: translations = locale.translations, super(child: child);

	@override
	bool updateShouldNotify(_InheritedLocaleData oldWidget) {
		return oldWidget.locale != locale;
	}
}

// pluralization resolvers

typedef PluralResolver = String Function(num n, {String? zero, String? one, String? two, String? few, String? many, String? other});

// prepared by fast_i18n

String _pluralCardinalEn(num n, {String? zero, String? one, String? two, String? few, String? many, String? other}) {
	if (n == 0) {
		return zero ?? other!;
	} else if (n == 1) {
		return one ?? other!;
	}
	return other!;
}

// helpers

final _localeRegex = RegExp(r'^([a-z]{2,8})?([_-]([A-Za-z]{4}))?([_-]?([A-Z]{2}|[0-9]{3}))?$');
AppLocale? _selectLocale(String localeRaw) {
	final match = _localeRegex.firstMatch(localeRaw);
	AppLocale? selected;
	if (match != null) {
		final language = match.group(1);
		final country = match.group(5);

		// match exactly
		selected = AppLocale.values
			.cast<AppLocale?>()
			.firstWhere((supported) => supported?.languageTag == localeRaw.replaceAll('_', '-'), orElse: () => null);

		if (selected == null && language != null) {
			// match language
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.startsWith(language) == true, orElse: () => null);
		}

		if (selected == null && country != null) {
			// match country
			selected = AppLocale.values
				.cast<AppLocale?>()
				.firstWhere((supported) => supported?.languageTag.contains(country) == true, orElse: () => null);
		}
	}
	return selected;
}

// translations

// Path: <root>
class _StringsEn {

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	_StringsEn.build({PluralResolver? cardinalResolver, PluralResolver? ordinalResolver})
		: _cardinalResolver = cardinalResolver,
		  _ordinalResolver = ordinalResolver;

	/// Access flat map
	dynamic operator[](String key) => _flatMap[key];

	// Internal flat map initialized lazily
	late final Map<String, dynamic> _flatMap = _buildFlatMap();

	// ignore: unused_field
	final PluralResolver? _cardinalResolver;
	// ignore: unused_field
	final PluralResolver? _ordinalResolver;

	// ignore: unused_field
	late final _StringsEn _root = this;

	// Translations
	String get requiredField => 'Please fill this field.';
	String get word => 'Word';
	String get name => 'Name';
	String get definition => 'Definition';
	String get example => 'Example';
	String get mnemonic => 'Mnemonic';
	String get level => 'Level';
	String get newWord => 'New';
	String get updateWord => 'Update';
	String get sun => 'Sun';
	String get mon => 'Mon';
	String get tue => 'Tue';
	String get wed => 'Wed';
	String get thu => 'Thu';
	String get fri => 'Fri';
	String get sat => 'Sat';
	String get alarm => 'Alarm';
	String get annoyer => 'Annoyer';
	String get practiceNotifier => 'Bump yourself up!';
	String get testNotifier => 'End of the day!';
	String get practice => 'Practice';
	String get test => 'Test';
	String get noWordToShow => 'There is no word to show.';
	String get dictionary => 'Dictionary';
	String get settings => 'Settings';
	String get searchDefinition => 'Search definition';
	String get notFound => 'Not found';
	String get loading => 'Loading';
	String get giveUp => 'Give up';
	String get backup => 'Backup';
	String get restore => 'Restore';
	String get viewDefinition => 'View definition';
	String get viewExample => 'View example';
	String get viewMnemonic => 'View mnemonic';
	String totalNumWords({required num count}) => (_root._cardinalResolver ?? _pluralCardinalEn)(count,
		zero: 'No word',
		one: 'Total $count word',
		two: 'Total $count words',
		many: 'Total $count words',
		other: 'Total $count words',
	);
	String wordsSelected({required num count}) => (_root._cardinalResolver ?? _pluralCardinalEn)(count,
		zero: 'No word selected',
		one: '$count word selected',
		two: '$count words selected',
		many: '$count words selected',
		other: '$count words selected',
	);
	String get atLeast4WordsRequired => 'At least four words are required.';
	String get storagePermissionRequired => 'Storage permission is required.';
	String get idiom => 'Idiom';
	String get wordOrIdiom => 'Word or Idiom';
	String get practiceChannelDescription => 'Practice makes you great.';
	String get testChannelDescription => 'Test makes you perfect.';
	String get training => 'Training';
	String get askDefinition => 'What is the definition of';
	String get askWord => 'Fill in the blanks in the following sentence.';
	String get dataManagement => 'Data management';
	String get sync => 'Sync';
}

/// Flat map(s) containing all translations.
/// Only for edge cases! For simple maps, use the map function of this library.

extension on _StringsEn {
	Map<String, dynamic> _buildFlatMap() {
		return {
			'requiredField': 'Please fill this field.',
			'word': 'Word',
			'name': 'Name',
			'definition': 'Definition',
			'example': 'Example',
			'mnemonic': 'Mnemonic',
			'level': 'Level',
			'newWord': 'New',
			'updateWord': 'Update',
			'sun': 'Sun',
			'mon': 'Mon',
			'tue': 'Tue',
			'wed': 'Wed',
			'thu': 'Thu',
			'fri': 'Fri',
			'sat': 'Sat',
			'alarm': 'Alarm',
			'annoyer': 'Annoyer',
			'practiceNotifier': 'Bump yourself up!',
			'testNotifier': 'End of the day!',
			'practice': 'Practice',
			'test': 'Test',
			'noWordToShow': 'There is no word to show.',
			'dictionary': 'Dictionary',
			'settings': 'Settings',
			'searchDefinition': 'Search definition',
			'notFound': 'Not found',
			'loading': 'Loading',
			'giveUp': 'Give up',
			'backup': 'Backup',
			'restore': 'Restore',
			'viewDefinition': 'View definition',
			'viewExample': 'View example',
			'viewMnemonic': 'View mnemonic',
			'totalNumWords': ({required num count}) => (_root._cardinalResolver ?? _pluralCardinalEn)(count,
				zero: 'No word',
				one: 'Total $count word',
				two: 'Total $count words',
				many: 'Total $count words',
				other: 'Total $count words',
			),
			'wordsSelected': ({required num count}) => (_root._cardinalResolver ?? _pluralCardinalEn)(count,
				zero: 'No word selected',
				one: '$count word selected',
				two: '$count words selected',
				many: '$count words selected',
				other: '$count words selected',
			),
			'atLeast4WordsRequired': 'At least four words are required.',
			'storagePermissionRequired': 'Storage permission is required.',
			'idiom': 'Idiom',
			'wordOrIdiom': 'Word or Idiom',
			'practiceChannelDescription': 'Practice makes you great.',
			'testChannelDescription': 'Test makes you perfect.',
			'training': 'Training',
			'askDefinition': 'What is the definition of',
			'askWord': 'Fill in the blanks in the following sentence.',
			'dataManagement': 'Data management',
			'sync': 'Sync',
		};
	}
}
