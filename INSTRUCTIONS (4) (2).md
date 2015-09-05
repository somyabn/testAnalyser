Magoosh Questionnaire
=====================
This questionnaire is intended to be a quick test of your technical coding and
design skills. We expect that answering both of these questions will take less
than two hours total.

When you're done, you can attach your solutions to your email as a .zip file or
upload them to https://gist.github.com/ and send us the link. Feel free to use
any language that you assume a junior developer could understand.

Have fun!

(And if anything's unclear or you think these questions/time estimates could be
improved, let us know :smile:)

1. Item Discrimination (~1 hour)
--------------------------------
We have some graded answer records from a practice exam in a file (answers.json,
attached) one answer per line, JSON-encoded. We want to analyze the answers to
find the lowest-quality questions using an Item Discrimination algorithm:

* Separate test-takers into three cohorts (top, middle, bottom) by their overall
  score on the test, excluding skipped questions
* For each question, calculate the fraction of answers by the top cohort which
  were correct and subtract the fraction of correct answers by the bottom cohort

Write a program that will read the full list of answers and output the name and
Item Discrimination for each question, sorted by their Item Discrimination
(ascending). Your final code should cleaned up and ready for code review.

...and in case you're wondering: Item Discrimination (which has range of -1.0 to
1.0) roughly indicates how well the question evaluates student ability. Values
above 0.3 are generally good questions, values between 0.0 and 0.3 are mediocre,
and values under 0.0 usually have errors in their grading)

2. Student & Parent Accounts (~1/2 hour)
----------------------------------------
We originally designed our account and subscription system (described below)
under the assumption that the same person purchases and uses an account (which
is almost always true for grad school exams). However, we recently found that
our high school students usually have parents pay for their account and often
the parent is purchasing multiple accounts. This is creating issues with
features such as study reminders and receipt emails where our messages are being
sent to the wrong person and profiles are a jumble of parent and student info.

How would you alter this design to handle separate student and parent accounts?

**Exam** - A product/site for an exam's worth of study content
```
has_many :subscription_plans
has_many :user_profiles
```

**User** - A single student's account (email, password, etc.)
```
has_many :user_profiles
```

**UserProfile** - A student's exam-specific settings (target scores, test date,
disability accomodations, etc.)
```
belongs_to :user
belongs_to :exam
has_many :subscriptions
```

**SubscriptionPlan** - A paid or free plan with configured access to a certain
amount of content from a single exam
```
belongs_to :exam
has_many :subscriptions
```

**Subscription** - Records trial sign-up, purchase, upgrade, or extension of a
user's access to a particular plan with activation and expiration dates. A
welcome and/or receipt email is sent to the user after activation. Each
profile has at most one active subscription.
```
belongs_to :subscription_plan
belongs_to :user_profile
has_many :subscription_transactions
```

**SubscriptionTransaction** - Record of each payment request for a subscription.
If the payment is successful, then the subscription is activated. Otherwise,
an error description is shown to the user and an email is scheduled to ask the
user if they need help processing their payment.
```
belongs_to :subscription
```
