"use strict";
var { withShortcut, ShortcutProvider, ShortcutConsumer } = require('react-keybind');

exports.shortcutProviderImpl = ShortcutProvider;
exports.shortcutConsumerImpl = ShortcutConsumer;
exports.withShortcutImpl = withShortcut;

exports.shortcutId           = (shortcut) => shortcut.id;
exports.shortcutDescription  = (shortcut) => shortcut.description;
exports.shortcutHold         = (shortcut) => shortcut.hold;
exports.shortcutHoldDuration = (shortcut) => shortcut.holdDuration;
exports.shortcutKeys         = (shortcut) => shortcut.keys;
// exports.shortcutMethod       = (shortcut) => shortcut.method;
exports.shortcutSequence     = (shortcut) => shortcut.sequence;
exports.shortcutTitle        = (shortcut) => shortcut.title;
