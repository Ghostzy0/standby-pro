# Security policy

Standby Pro is an early open-source bedside display. Source prereleases and browser previews have limited device validation; no native production signing or security certification is claimed. Supported development is on the latest preview; the separate baseline is archival.

Do not post credentials, personal calendars, device identifiers or private screenshots in public issues. Use GitHub private vulnerability reporting if it is enabled on this repository; otherwise contact the owner privately through an available channel before sharing exploit details. No guaranteed response time is offered.

The app has no account, analytics, ads or payment flow. Preferences are local. Weather is optional and calls Open-Meteo directly, disclosing IP and selected public-city coordinates to that provider. Do not use the free endpoint for a commercial product without service rights. Native builds should request only permissions they implement; never add broad calendar/location/media access as a workaround.

Release signing keys must remain outside Git. Verify SHA256 manifests and source tags before running downloaded previews. Debug signing is not a production release identity. Never run install scripts from comments or unknown issue attachments.
