# Introduction

This test case is used for exporting my monthly Grab E-Receipt to do my transportation claims.

This test case does not rely on gecko's new firefox instance for testing, it uses the existing user's firefox browser for instance creation. The advantage of this approach will be to avoid the need to perform a login flow with google authentication service, and can depend on existing logged in google session to perform testing immediately. You can refer to the [following issue](https://superuser.com/questions/1511719/i-cant-login-to-gmail-with-selenium-anymore), to understand a common issue with default selenium driver approach.

# What you need

- [Firefox Web Browser](https://www.mozilla.org/en-US/firefox/new/) - the version tested Firefox 88.0.1 (64-bit) on Ubuntu 20.04
- [Gecko Driver](https://github.com/mozilla/geckodriver/releases) - version tested 0.29.1
- Logged in gmail account on your firefox, when you enter "https://gmail.com/" - it should go to your inbox instead of a login page.

