# motiontag_sdk_example

Demonstrates how to use the `motiontag` plugin.

Uses the [`permission_handler`](https://pub.dev/packages/permission_handler)
package to manage the app permissions.

## Setup

Before running the app, add your MOTIONTAG user token to `lib/onboarding_screen.dart`:

```dart
static const _userToken = 'YOUR_TOKEN_HERE';
```

A token can be obtained from the [MOTIONTAG developer portal](https://api.motion-tag.de/developer/).
