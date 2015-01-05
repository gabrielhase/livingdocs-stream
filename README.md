
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

In order to run this locally, you also need a running local version of the [livingdocs-api](https://github.com/upfrontIO/livingdocs-api/).

## Running

The simplest way to run it is:

```
./start
```
Your server will then run at `localhost:3000`.

You also have the option to choose different environments with the `--env` parameter. *Currently, there is no API on production that would work with this app, so don't use the production environment yet.*

You can run the app on the IOS simulator with:
```
./start --env ios
```

You can also start the app for development on XCode (and running on a native device) with:
```
./start --env mobiledev
```

### URL Setting

The app uses the livingdocs-api webhooks to get notified of new publications in real-time. In order to work, the app needs to know the URL it is working under. The livingdocs-api *does not allow the url to be on localhost* so if you develop locally you need to make sure that you use a local URL mapper, e.g., pagekite. Once you have a mapped URL, enter it in the respective settings file, e.g., development/settings.json`.
