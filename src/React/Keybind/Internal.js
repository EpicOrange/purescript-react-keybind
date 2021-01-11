"use strict";
var { withShortcut, ShortcutProvider, ShortcutConsumer } = require('react-keybind');

exports.shortcutProviderImpl = ShortcutProvider;
exports.shortcutConsumerImpl = ShortcutConsumer;
exports.withShortcutImpl = withShortcut;

exports.unsafeApplyRegisterShortcut = (registerShortcut) => (spec) => () => {
  if (spec.method === undefined || spec.keys === undefined)
    throw new Error("purescript-react-keybind: called registerShortcut without method or key!");
  registerShortcut(
    spec.method,
    spec.keys,
    spec.title || "",
    spec.description || "",
    +spec.holdDuration || undefined);
};
exports.unsafeApplyRegisterSequenceShortcut = (registerSequenceShortcut) => (spec) => () => {
  if (spec.method === undefined || spec.keys === undefined)
    throw new Error("purescript-react-keybind: called registerSequenceShortcut without method or key!");
  registerSequenceShortcut(
    spec.method,
    spec.keys,
    spec.title || "",
    +spec.holdDuration || undefined);
};
