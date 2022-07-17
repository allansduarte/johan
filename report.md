# Level 6

## Caregiver does not receive the SMS or is not near its phone
It's possible to build a fan-out message delivery system if the caregiver isn't available in a timely manner.

## How does the caregiver enters the patient's house?
I will not focus in the logistic way. If it's legally permit a caregiver to enter in the patient house so it's possible to support the caregiver with some good experience route system.

## What if our system is down? any ways to limit point of failure?

- Backup and redundant systems and software components ensure against the loss of a primary system.
- Load balancers send requests for service only to servers that are online and in use. As a result, load balancing reduces the threat of single point of failure where multiple servers are in use.
- Avoid failure with tests and monitoring.
- Avoid message loss with backpressure strategies and fault-tolerance.