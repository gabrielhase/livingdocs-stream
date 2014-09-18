
# Livingdocs Stream

## What is this

This is a prototyping repository to explore what's possible with the [livingdocs-api](https://github.com/upfrontIO/livingdocs-api/). It explores a simple stream-based output for desktops and mobiles and uses Meteor.JS as a quick prototyping environment.

If you want to make your own explorations and use the existing code, please make a fork of this repository.

If you want to try something out in the context of this exploration, work with a branch.

This code does not adhere to upfront.io code quality standards. We would never use code such as this in a product. This is only for exploration.

## Installing

```
curl https://install.meteor.com | /bin/sh
```

You also need a running local version of the [livingdocs-api](https://github.com/upfrontIO/livingdocs-api/). Currently, it only works with the branch 'support-delivery'.

## Running

The simplest way to run it is:

```
./start
```
Your server will then run at `localhost:3000`.

You also have the option to choose different environments with the `--env` parameter. *Currently, there is no API on either staging or production that would work with this app, so don't use these environments yet.*

You can run the app on the IOS simulator with:
```
./start --env ios
```

You can also start the app for development on XCode (and running on a native device) with:
```
./start --env mobiledev
```
*This is currently broken though, I am guessing on a load order problem*
