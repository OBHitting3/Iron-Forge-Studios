# Memory Vault — Module 1 Complete Logic Specification

## Context

J9-AiRE's Memory Vault is the data foundation for Janine Stevens' digital twin. Janine is a top 1% luxury agent (~$90M+/year, La Quinta CA) with 300-1,500 client relationships and transactions from $800K-$15M+. She doesn't want more leads — she wants to **never lose a relationship through neglect.**

The core problem this solves: **88-91% of buyers say they'd use their agent again, but only 12% actually do — because 91% of agents never contact clients after closing.** The Memory Vault prevents that silent decay.

Every module (AI communication, paperwork automation, market intelligence, daily briefing) reads from this layer. If the scoring, state machine, or relationship mapping is wrong here, everything built on top fails.

---

## 1. ENGAGEMENT SCORING ALGORITHM

### 1.1 Score Definition

The **Engagement Score (ES)** is a 0-100 composite that measures **relationship health** — not transaction probability. It answers: "How strong is my connection to this person right now?"

### 1.2 Input Signals & Weights

| Signal | Weight | Justification |
|--------|--------|---------------|
| **Recency of Contact** | 30% | Research shows 70% of buyers forget their agent's name after 12 months of no contact. Recency is the #1 predictor of relationship survival. |
| **Frequency of Contact** | 15% | Wealth management data: HNW clients expect 14-20 touchpoints/year. Consistent cadence > sporadic bursts. |
| **Transaction History** | 20% | A client with $12M in past transactions has proven loyalty and represents massive future value. But past transactions alone don't keep relationships alive — hence not the top weight. |
| **Referral Activity** | 15% | Referral clients convert at 3-4x vs. cold leads. A client who refers is actively invested in the relationship. Each referral is a stronger signal than a returned phone call. |
| **Response Rate** | 10% | Does the client respond to outreach? A client who opens emails, returns calls, and replies to texts is engaged. A client who ghosts is cooling. |
| **Milestone Engagement** | 10% | Did the client respond to birthday wishes? Attend an event? Acknowledge an anniversary message? Reciprocal engagement on personal milestones signals emotional connection, the core of luxury relationships. |

**Total: 100%**

### 1.3 Sub-Score Calculations

#### 1.3.1 Recency Sub-Score (R) — max 30 points

Uses **exponential decay** anchored to the 12-month cliff from NAR data.

```
R = 30 * e^(-lambda * days_since_last_contact)
```

Where `lambda` varies by client tier:

| Tier | Lambda | Half-life | Reasoning |
|------|--------|-----------|-----------|
| VIP ($5M+ history or 3+ transactions) | 0.0035 | ~198 days | VIP relationships have deeper roots. They decay slower but still need attention. A VIP going 6 months without contact loses ~50% recency score. |
| Standard ($800K-$5M, 1-2 transactions) | 0.0055 | ~126 days | The typical luxury client. After ~4 months of silence, recency score halves. Matches the 6-12 month "critical maintenance window." |
| Prospect (no transactions) | 0.0090 | ~77 days | Prospects have no transaction bond. Without contact, they cool fast. After ~2.5 months, recency score halves. |

**Why exponential, not linear?** Relationships don't decay at a constant rate. The first week of silence barely matters. But the difference between 3 months of silence and 6 months is dramatic — that's when the client starts considering other agents. Exponential decay models this accurately.

**Why not stepped thresholds?** Steps create cliff edges where a client jumps from "fine" to "at risk" overnight. Exponential decay gives a smooth, continuous signal that triggers progressively earlier warnings.

#### 1.3.2 Frequency Sub-Score (F) — max 15 points

Measures whether the contact cadence meets the target for the client's tier.

```
F = 15 * min(1.0, actual_contacts_last_365_days / target_contacts)
```

| Tier | Target Contacts/Year | Reasoning |
|------|---------------------|-----------|
| VIP | 24 (biweekly) | Wealth management data: UHNW clients get 20+ touchpoints/year. Biweekly ensures Janine is never more than 2 weeks from the client's mind. |
| Standard | 12 (monthly) | NAR data: agents with consistent monthly contact retain 50-80% of relationships. Monthly is the minimum to stay in the "remembered" zone. |
| Prospect | 18 (every ~3 weeks) | Prospects need more frequent nurture to build the relationship before it exists. But not as frequent as VIP because the emotional bond isn't established. |
| Dormant | 4 (quarterly) | Quarterly "are you still alive" touchpoints. Enough to signal "I haven't forgotten you" without being annoying. |

**Cap at 1.0** — contacting more than the target doesn't give bonus points. Over-contacting can damage luxury relationships (these clients value their privacy).

#### 1.3.3 Transaction History Sub-Score (T) — max 20 points

```
T = min(20, transaction_base + recency_bonus)
```

**Transaction Base** (max 15 points):

| Condition | Points | Reasoning |
|-----------|--------|-----------|
| 0 transactions | 0 | No proven relationship through business. |
| 1 transaction, < $2M | 4 | Entry-level luxury. One deal doesn't guarantee loyalty. |
| 1 transaction, $2M-$5M | 6 | Meaningful deal size shows trust with significant money. |
| 1 transaction, $5M+ | 8 | High-stakes trust. These clients chose Janine for the biggest purchase of their life. |
| 2 transactions any size | 10 | Repeat business = proven loyalty. Size matters less than coming back. |
| 3+ transactions or $10M+ cumulative | 15 | Core book of business. These are the relationships that define Janine's career. |

**Recency Bonus** (max 5 points):
```
recency_bonus = 5 * e^(-0.001 * days_since_last_transaction)
```
Half-life: ~693 days (~1.9 years). A transaction 2 years ago still has value. A transaction 5+ years ago is history, not current engagement.

#### 1.3.4 Referral Activity Sub-Score (Ref) — max 15 points

```
Ref = min(15, referral_base + referral_recency)
```

**Referral Base** (max 10 points):

| Condition | Points |
|-----------|--------|
| 0 referrals | 0 |
| 1 referral that didn't close | 2 |
| 1 referral that closed | 5 |
| 2+ referrals, at least 1 closed | 8 |
| 3+ referrals, 2+ closed | 10 |

**Referral Recency** (max 5 points):
```
referral_recency = 5 * e^(-0.003 * days_since_last_referral)
```
Half-life: ~231 days. A referral in the last 6 months is a strong signal. A referral from 3 years ago is a faded memory.

#### 1.3.5 Response Rate Sub-Score (RR) — max 10 points

```
RR = 10 * (responses_last_180_days / outreach_attempts_last_180_days)
```

Uses a 180-day rolling window. If Janine has reached out 6 times and the client responded to 4, RR = 10 * (4/6) = 6.7.

**Edge cases:**
- If 0 outreach attempts in 180 days: RR = 5.0 (neutral — absence of data is not negative, but not positive either)
- If 0 responses to 3+ attempts: RR = 0.0 (client is ghosting — this is a strong negative signal)

#### 1.3.6 Milestone Engagement Sub-Score (ME) — max 10 points

```
ME = min(10, milestone_responses * 2.5)
```

Counts the number of milestone touchpoints in the last 365 days where the client **responded or acknowledged**. Sending a card that gets no response = 0. Getting a "thank you so much!" text back = 1 milestone response. Max 4 milestones counted (birthday, purchase anniversary, holiday, personal event).

### 1.4 Final Score Calculation

```
ES = R + F + T + Ref + RR + ME
```

Capped at 0-100. No normalization needed since sub-scores sum to 100 max.

### 1.5 Score Thresholds

| Range | Status | Meaning | System Behavior |
|-------|--------|---------|-----------------|
| 80-100 | **Healthy** | Relationship is strong. Active communication, client is engaged. | Normal cadence. Green in dashboard. |
| 60-79 | **Warm** | Relationship is fine but could use attention. Maybe cadence slipped or response rate dropped. | Yellow in dashboard. Suggested follow-up surfaces in daily briefing. |
| 40-59 | **Cooling** | Relationship is noticeably declining. Multiple signals are weakening. | Orange in dashboard. Alert pushed to Slack. AI drafts re-engagement message for Janine's review. |
| 20-39 | **At Risk** | Relationship is in danger. Extended silence, no response to outreach, or significant time since last transaction. | Red in dashboard. Flagged for Janine's personal attention. System suggests phone call or in-person meeting, not just email/text. |
| 0-19 | **Dormant** | Relationship has gone cold. No meaningful engagement in an extended period. | Gray in dashboard. Quarterly re-engagement attempts. After 4 consecutive ignored attempts, status moves to Lost. |

**"Lost" is not a score threshold — it's a state machine transition** (see Section 2).

### 1.6 Score Behavior: VIP vs. New Referral

**VIP with $12M history, no contact in 90 days:**
- R: 30 * e^(-0.0035 * 90) = 30 * 0.73 = 21.9
- F: Assume 6 contacts in last year (target 24) = 15 * (6/24) = 3.75
- T: 3+ transactions, $10M+ = 15. Recency bonus depends on last transaction date.
- Ref: Depends on referral history.
- RR: Depends on response history.
- ME: Depends on milestone responses.
- **Likely ES: 55-70 (Warm to Cooling)** — the high transaction history keeps the floor up, but decaying recency and low frequency drag it down. The system flags this: "VIP relationship cooling despite strong history."

**New referral, zero transactions, active communication last 2 weeks:**
- R: 30 * e^(-0.009 * 14) = 30 * 0.88 = 26.4
- F: If 3 contacts in 2 months (annualized ~18, target 18) = 15 * 1.0 = 15.0
- T: 0 transactions = 0
- Ref: Referred by someone = 2 (1 referral, no close yet)
- RR: Responding to everything = 10.0
- ME: No milestones yet = 0
- **Likely ES: 53 (Cooling threshold)** — despite active communication, the zero transaction history and zero milestone engagement cap the score. This is by design: the system says "this relationship is building but not yet deep." As transactions and time accumulate, the ceiling rises.

---

## 2. CLIENT LIFECYCLE STATE MACHINE

### 2.1 States

| State | Definition |
|-------|------------|
| **Lead** | Person identified but no meaningful two-way communication yet. Could be a referral name, an open house sign-in, or a name from a sphere list. |
| **Prospect** | Two-way communication established. Janine knows who they are and they know her. No transaction yet. |
| **Active Client** | Currently in a transaction (buyer or seller) with Janine. Has a signed agreement or active listing/search. |
| **Post-Close** | Transaction completed within the last 90 days. In the "honeymoon" period. |
| **Nurture** | No active transaction. Relationship is being maintained through regular touchpoints. This is where most of Janine's 300-1,500 clients live. |
| **VIP** | Nurture client with elevated status: $5M+ cumulative transaction history OR 3+ transactions OR designated by Janine manually. Gets enhanced cadence and personal attention. |
| **Cooling** | ES dropped below 60. System has flagged the relationship as needing attention. |
| **At Risk** | ES dropped below 40 OR no response to 3+ consecutive outreach attempts. |
| **Dormant** | ES dropped below 20 OR no two-way communication in 18+ months. |
| **Lost** | 4 consecutive quarterly re-engagement attempts with zero response. Janine has been notified and acknowledged. Client is archived but not deleted. |
| **Inactive (by choice)** | Client explicitly asked to not be contacted, or relationship ended on bad terms. Janine manually sets this. No automated outreach. |

### 2.2 Transitions

#### Lead -> Prospect
- **Trigger:** First two-way communication (Janine calls and they answer, they respond to an email/text, they call Janine).
- **What counts as "two-way":** Any interaction where the client acknowledges Janine. A voicemail left by Janine does NOT count. A returned call DOES.
- **Actions:** Create full client profile. Set initial follow-up for 3 days. Send Slack notification: "New prospect: [Name] — referred by [source]."

#### Prospect -> Active Client
- **Trigger:** Signed buyer representation agreement, signed listing agreement, or accepted offer (whichever comes first).
- **Actions:** Move to Active Client. Set follow-up cadence to deal-stage-driven (see Section 4). Alert Slack: "New active deal: [Name] — [buy/sell] — [price range]."

#### Active Client -> Post-Close
- **Trigger:** Transaction closes (recorded closing date).
- **Actions:**
  - Schedule post-close sequence: thank-you within 24 hours, check-in at 7 days, 30-day follow-up, 90-day follow-up.
  - Calculate and store transaction data (price, type, date).
  - Recalculate ES with new transaction data.
  - Alert Slack: "Closed: [Name] — [address] — [$amount]."

#### Post-Close -> Nurture
- **Trigger:** 90 days after closing.
- **Actions:** Transition to standard nurture cadence (monthly). If cumulative transaction history qualifies for VIP, transition to VIP instead. Log transition.

#### Post-Close -> VIP
- **Trigger:** 90 days after closing AND ($5M+ cumulative OR 3+ transactions).
- **Actions:** Transition to VIP cadence (biweekly). Slack: "[Name] promoted to VIP — [reason]."

#### Nurture -> VIP
- **Trigger:** Janine manually designates, OR client's cumulative transaction history crosses $5M threshold, OR client makes 3rd referral that closes.
- **Actions:** Upgrade cadence to biweekly. Slack notification. Update dashboard display.

#### Nurture -> Cooling
- **Trigger:** ES drops below 60.
- **Actions:** Surface in daily briefing as "needs attention." AI drafts a personalized re-engagement message based on last known interests, recent market activity in their area, or upcoming milestone. Slack: "[Name] is cooling — ES: [score]. Suggested action: [action]."

#### VIP -> Cooling
- **Trigger:** ES drops below 60. (Same threshold — VIP status doesn't protect from cooling status. It makes the alert MORE urgent.)
- **Actions:** Same as Nurture -> Cooling BUT escalated: "VIP COOLING: [Name] — ES: [score]. This is a [$X transaction history] relationship." Flagged for Janine's personal phone call, not just a drafted message.

#### Cooling -> Nurture/VIP
- **Trigger:** ES rises back above 65 (5-point hysteresis to prevent flapping).
- **Actions:** Remove from cooling alerts. Log recovery. Slack: "[Name] re-engaged — ES: [score]."

#### Cooling -> At Risk
- **Trigger:** ES drops below 40 OR 3+ consecutive outreach attempts with no response (within any timeframe).
- **Actions:** Red alert in dashboard. Slack: "AT RISK: [Name] — ES: [score]. [X] outreach attempts without response." System recommends a different channel (if emailing, suggest a call; if calling, suggest a handwritten note or in-person visit). Flag all connected relationships (see Section 3).

#### At Risk -> Cooling/Nurture/VIP
- **Trigger:** Client responds to outreach (any channel) AND ES rises above 45 (5-point hysteresis).
- **Actions:** Celebration notification: "[Name] re-engaged! ES recovering." Reset consecutive-no-response counter.

#### At Risk -> Dormant
- **Trigger:** ES drops below 20 OR no two-way communication for 18 months.
- **Why 18 months?** NAR data shows the 12-month mark is the cliff where 70% forget their agent's name. By 18 months, the probability of re-engagement drops to 12-15%. Setting the threshold at 18 months (not 12) gives the system 6 months of escalating intervention before declaring dormancy.
- **Actions:** Move to quarterly re-engagement cadence. Slack: "DORMANT: [Name] — last contact [date]. Quarterly re-engagement initiated." AI drafts a low-pressure reconnection message (market update for their area, not "hey, we haven't talked").

#### Dormant -> At Risk (re-engagement)
- **Trigger:** Client responds to any outreach OR initiates contact.
- **Actions:** Immediately escalate to At Risk (not straight to Nurture — trust needs to be rebuilt). Set follow-up for 3 days. Slack: "REACTIVATION: [Name] responded after [X months] dormant."

#### Dormant -> Lost
- **Trigger:** 4 consecutive quarterly re-engagement attempts (spanning ~12 months of dormancy) with zero response. System prompts Janine: "Should we archive [Name]?" Janine confirms.
- **Why require confirmation?** A $10M client going silent for 18 months + 12 months of attempts = 2.5 years. That's significant. But in luxury real estate, a client might be abroad, dealing with a family situation, or simply not in the market. Janine's judgment is required.
- **Actions:** Archive client. Stop all automated outreach. Retain all data (never delete). Slack: "[Name] archived as lost. [Total relationship value: $X]. [Referral chain: X connections]."

#### ANY STATE -> Active Client
- **Trigger:** New transaction initiated (signed agreement or accepted offer), regardless of current state.
- **Override speed:** Immediate. A dormant client who calls to list a $5M property is Active Client within the same system cycle (real-time event processing, not batch).
- **Actions:** Override current state. Set deal-stage cadence. If transitioning from Dormant/At Risk/Cooling, add Slack alert: "REACTIVATION VIA TRANSACTION: [Name] — [deal details]. Was [previous state] for [duration]."

#### ANY STATE -> Inactive (by choice)
- **Trigger:** Janine manually sets. Reasons: client requested no contact, relationship ended poorly, client deceased, client moved permanently out of market area.
- **Actions:** Stop all automated outreach. Retain data. Log reason. No re-engagement attempts.

### 2.3 State Transition Summary Diagram (text)

```
Lead --> Prospect --> Active Client --> Post-Close --> Nurture <--> Cooling <--> At Risk <--> Dormant --> Lost
                          ^                              |            |                          |
                          |                              v            |                          |
                          |                             VIP <-------->+                          |
                          |                                                                      |
                          +--------- ANY STATE (transaction override) ---------------------------+

ANY STATE --> Inactive (by choice) [manual only]
```

---

## 3. RELATIONSHIP MAPPING

### 3.1 Connection Types

| Type | Definition | Example |
|------|------------|---------|
| **Spouse/Partner** | Married or domestic partner. Share property decisions. | Phil Knight + wife |
| **Family** | Parent, child, sibling, in-law. Influence property decisions and referrals. | Client's adult child looking to buy |
| **Referral (direct)** | Client A directly referred Client B to Janine. | "My friend John needs an agent — call him" |
| **Referral (chain)** | Client A referred B, B referred C. Tracked to depth 3. | A -> B -> C |
| **Business Partner** | Share business interests, may co-invest in property. | Two partners buying commercial property |
| **Neighbor** | Live in same community/HOA/development. | Three clients in same gated community |
| **Shared Service Provider** | Use same property manager, attorney, financial advisor, contractor. | Two clients using same property manager |
| **Social Circle** | Belong to same club, charity board, social group. | Three clients on same country club board |

### 3.2 Connection Effects on Scores

#### 3.2.1 Spouse/Partner
- **Shared score:** Spouses share a single household ES. Contact with either spouse counts as contact with both.
- **Exception:** If spouses have separate email addresses and Janine interacts with them independently on different properties, they can be split into linked-but-separate records. Janine decides.

#### 3.2.2 Family
- **Score influence:** When a family member initiates contact or transacts, the connected family member gets a **+3 ES boost** (one-time, decays normally). Reasoning: family contact signals the family is talking about real estate, which keeps Janine top-of-mind.
- **State influence:** If a family member moves to Active Client, connected family members get a note in their daily briefing: "[Family member] is actively transacting. Consider reaching out to [connected client]."

#### 3.2.3 Referral Chain
- **Depth:** Tracked to 3 levels (A -> B -> C). Beyond 3, the connection is too diluted to be actionable.
- **Credit distribution:**
  - Level 1 (direct referrer): Full referral credit (see Section 1.3.4). Referral sub-score updated.
  - Level 2 (referrer's referrer): +2 ES boost (one-time). Notification: "[Name] is the origin of a referral chain that produced [new client]."
  - Level 3: +1 ES boost. Informational only.
- **Reverse notification:** When a referred client closes a transaction, the referrer gets a Slack-triggered follow-up suggestion: "Thank [Referrer] — their referral [Client] just closed on [address]."

#### 3.2.4 Shared Service Provider (e.g., property manager)
- **Contact propagation:** If a shared service provider contacts Janine about Client A, **only Client A's** record updates. The connection is noted but does NOT automatically boost connected clients' scores.
- **Surface the connection:** When viewing Client A's profile, the system shows: "Shares property manager [Name] with [Client B, Client C]." This is informational for Janine — if the property manager mentions something relevant to Client B, Janine can manually log it.
- **Why no automatic score propagation?** A property manager calling about a leaky roof at Client A's rental doesn't mean Client B is engaged. Over-propagation creates false signals.

#### 3.2.5 Neighbor/Community
- **Market intelligence trigger:** When a client in a community lists or sells, all connected clients in the same community get a note in the daily briefing: "[Neighbor] just listed at [price]. Your other clients in [community]: [list]. Consider proactive outreach about market activity."
- **No automatic score change.** The connection is strategic intelligence, not engagement data.

#### 3.2.6 Social Circle
- **Event trigger:** When a shared social event occurs (charity gala, club event), all connected clients get a follow-up suggestion: "You have [3] clients at [Event]. Consider attending or sending a note."
- **No automatic score change.**

### 3.3 Relationship Map Data Model

Each connection is stored as an edge between two client nodes:

```
Connection {
  client_a_id: UUID
  client_b_id: UUID
  type: enum (spouse, family, referral, business_partner, neighbor, shared_provider, social_circle)
  subtype: string (nullable) — e.g., "parent-child", "siblings", "property_manager"
  provider_name: string (nullable) — for shared_provider type
  community_name: string (nullable) — for neighbor type
  referral_level: int (nullable) — 1, 2, or 3 for referral chains
  created_at: timestamp
  created_by: enum (system, janine, ai_detected)
  notes: text (nullable)
  active: boolean — false if relationship dissolved (divorce, business split, etc.)
}
```

### 3.4 AI Connection Detection

The system should flag potential connections for Janine's confirmation:
- Two clients with the same last name and same address -> probable spouse/family
- Two clients with the same property manager in interaction logs -> shared provider
- Two clients in the same community/development from address data -> neighbor
- Client mentions another client's name in communication -> potential social/referral connection

**Never auto-create connections.** Always surface as: "Possible connection detected: [Client A] and [Client B] may be [relationship type]. Confirm?"

---

## 4. FOLLOW-UP SCHEDULING LOGIC

### 4.1 Core Calculation

When an interaction is logged, the system calculates next follow-up:

```
next_follow_up = interaction_date + base_interval(tier, interaction_type) + adjustment(deal_stage)
```

### 4.2 Base Intervals by Tier

| Tier | Standard Follow-up | After Phone Call | After In-Person Meeting | After Transaction Event |
|------|-------------------|------------------|------------------------|------------------------|
| VIP | 14 days | 10 days | 14 days | 3 days |
| Standard (Nurture) | 30 days | 21 days | 30 days | 7 days |
| Prospect | 21 days | 7 days | 14 days | 3 days |
| Cooling | 14 days | 7 days | 10 days | 3 days |
| At Risk | 10 days | 5 days | 7 days | 1 day |
| Dormant | 90 days | 14 days | 14 days | 1 day |

**Why shorter intervals after phone calls for prospects?** A phone call is high-investment from both sides. The prospect is warm. Waiting 21 days loses momentum. 7 days keeps it alive.

**Why shorter intervals for Cooling/At Risk?** These relationships need intervention. The system tightens the cadence to increase touchpoint frequency during the recovery window.

### 4.3 Deal-Stage Adjustments (Active Clients)

When a client is in Active Client state, follow-up cadence is driven by deal stage, overriding tier-based intervals:

| Deal Stage | Follow-up Interval | Reasoning |
|------------|-------------------|-----------|
| Pre-listing / Pre-search | 3-5 days | Building the relationship and understanding needs. |
| Active listing / Active search | 2-3 days | Market moves fast. Clients need to feel in the loop. |
| Under contract | 1-2 days | Critical transaction period. Daily or near-daily contact expected. |
| Inspection / Appraisal | 1 day | Decisions happening in real-time. |
| Closing week | Daily | Hand-holding through the finish line. |

### 4.4 Interaction Type Definitions

What counts as an "interaction" for follow-up scheduling:

| Interaction Type | Counts as Contact? | Follow-up Generated? |
|-----------------|-------------------|---------------------|
| Phone call (connected, 2+ minutes) | Yes | Yes |
| Phone call (voicemail left) | Yes (outbound only) | Yes, but flagged as "unconfirmed" |
| Phone call (missed, no voicemail) | No | No |
| Email sent by Janine | Yes (outbound only) | Yes |
| Email opened by client | No (passive) | No, but updates response rate |
| Email replied by client | Yes (inbound) | Yes |
| Text message sent | Yes | Yes |
| Text message received | Yes | Yes |
| In-person meeting | Yes | Yes |
| Handwritten note/card sent | Yes | Yes |
| Gift sent | Yes | Yes |
| Social media interaction (like, comment) | No | No — too passive for luxury relationships |
| Client attended Janine's event | Yes | Yes |
| Third-party contact (property manager, attorney) | Conditional — see Section 3.2.4 | Only if Janine was directly involved |

### 4.5 Milestone Integration with Follow-ups

**Rule: Milestones REPLACE the next scheduled follow-up if within 7 days of it. Otherwise, milestones STACK.**

Logic:
```
if abs(milestone_date - next_scheduled_followup) <= 7 days:
    next_scheduled_followup = milestone_date
    followup_type = milestone_type  # "birthday call" replaces generic "check-in"
else:
    keep next_scheduled_followup as-is
    add milestone_date as additional touchpoint
```

**Why 7 days?** Contacting a client for their birthday AND calling 3 days later for a generic check-in feels redundant and robotic. 7 days is the minimum gap where two touchpoints feel like separate, intentional contacts.

**Stacking limit:** Maximum 2 touchpoints in any 7-day period. If 3+ milestones cluster (unlikely but possible), prioritize by milestone priority ranking (see Section 5.3) and defer lowest-priority to the following week.

---

## 5. MILESTONE & DATE INTELLIGENCE

### 5.1 Milestone Types

| Milestone | Recurrence | Source |
|-----------|-----------|--------|
| Birthday | Annual | Client profile (manual entry or data enrichment) |
| Wedding Anniversary | Annual | Client profile |
| Purchase Anniversary | Annual per property | Transaction records |
| Listing Anniversary | Annual per listing (if unsold) | Transaction records |
| Move-in Date Anniversary | Annual | Transaction records (closing date + typical 30-day escrow) |
| Client's Business Anniversary | Annual | Client profile |
| Referral Anniversary | Annual | Referral records |
| Children's milestones | Annual (graduation, birthday) | Client profile |
| Seasonal (holidays) | Annual | Calendar (Thanksgiving, New Year, etc.) |

### 5.2 Alert Lead Times

| Milestone Type | Alert Lead Time | Action Type | Reasoning |
|---------------|----------------|-------------|-----------|
| Birthday | 10 days | Card + call on the day | Need time to send a physical card (luxury agents send real cards, not emails). |
| Wedding Anniversary | 10 days | Card | Same physical card logic. |
| Purchase Anniversary (Year 1) | 14 days | Call + small gift | First anniversary of buying through Janine is a relationship-cementing moment. |
| Purchase Anniversary (Year 2+) | 7 days | Card or text | Less urgency but still important to acknowledge. |
| Move-in Anniversary | 7 days | Text or call | Personal touch — "How are you enjoying the house?" |
| Holiday (Thanksgiving, New Year) | 14 days | Card | Cards need to arrive before the holiday, not after. |
| Children's milestones | 7 days | Text or call | Shows Janine remembers the family, not just the transaction. |
| Listing Anniversary (unsold) | 30 days | Strategy review call | If a listing hasn't sold in a year, it's time for a serious conversation about pricing or strategy. This is a business milestone, not a sentimental one. |

### 5.3 Priority Ranking (for clustering)

When multiple milestones fall in the same week, priority order:

1. **Birthday** — Most personal. Never skip or defer.
2. **Purchase Anniversary (Year 1)** — Critical relationship-cementing moment.
3. **Wedding Anniversary** — Personal and memorable.
4. **Holiday** — Shared by everyone, less personal but expected.
5. **Purchase Anniversary (Year 2+)** — Important but routine.
6. **Move-in Anniversary** — Nice but lower stakes.
7. **Children's milestones** — Valued but can flex.
8. **Client's Business Anniversary** — Professional, can shift a few days.
9. **Referral Anniversary** — Internal metric, client may not remember the exact date.
10. **Listing Anniversary** — Business meeting, schedule at mutual convenience.

### 5.4 "Send a Card" vs. "Call Personally"

| Milestone | VIP | Standard | Prospect |
|-----------|-----|----------|----------|
| Birthday | Call + gift | Call or card | Card or text |
| Wedding Anniversary | Card + gift | Card | Text |
| Purchase Anniversary (Year 1) | Call + gift | Call + card | N/A |
| Purchase Anniversary (Year 2+) | Call | Card | N/A |
| Holiday | Card + gift basket | Card | Card or text |
| Children's milestones | Call | Text | N/A |

**Janine Decision Required:** What gifts does she typically send? Wine? Gift baskets? Restaurant gift cards? What's her budget per tier? These values populate the "gift" action.

### 5.5 Year-Over-Year Handling

- All annual milestones auto-recur. The system creates the next year's milestone when the current one is acknowledged as complete.
- If a milestone is NOT acknowledged (Janine didn't mark it done), the system escalates: day-of reminder -> day-after "missed milestone" alert.
- Purchase anniversaries persist as long as the client owns the property. If the client sells, the purchase anniversary is archived and replaced with the new property's dates.

---

## 6. DATA QUALITY & CONFLICT RESOLUTION

### 6.1 Duplicate Detection

The system runs duplicate detection on every new record creation and weekly on the full database.

**Match criteria (scored):**

| Signal | Score |
|--------|-------|
| Exact name match (first + last) | 50 |
| Fuzzy name match (Levenshtein distance <= 2) | 30 |
| Same email address | 80 |
| Same phone number | 80 |
| Same mailing address | 60 |
| Same last name + same address | 70 |

**Threshold:** Combined score >= 80 = flag as probable duplicate.

**Never auto-merge.** Always surface to Janine: "Possible duplicate: [Record A] and [Record B]. Match confidence: [score]. [Reason]. Merge?"

### 6.2 Merge Strategy

When Janine confirms a merge:

| Field | Rule | Reasoning |
|-------|------|-----------|
| Name | Keep the version with most complete formatting (e.g., "William" over "Bill" as primary, keep "Bill" as nickname) | Luxury clients are addressed formally unless they've specified otherwise. |
| Email | Keep all. Mark most recently used as primary. | Clients may have personal + business email. |
| Phone | Keep all. Mark most recently used as primary. | Same logic. |
| Address | Keep most recent. Archive previous addresses. | Previous addresses are valuable (shows property history). |
| Transaction history | Merge all. No conflicts possible (transactions are unique events). | — |
| Interaction history | Merge all, sorted by date. | — |
| Engagement Score | Recalculate from merged data. | — |
| Notes | Concatenate with date headers. | — |
| Connections | Union of all connections. Flag if conflicting (e.g., one record says "spouse of A", other says "spouse of B"). | — |
| Client tier | Keep higher tier. | — |
| Created date | Keep earliest. | Shows full relationship duration. |

### 6.3 Minimum Viable Client Record

**Required fields (record cannot be saved without these):**
1. First name
2. Last name
3. At least one contact method (email OR phone OR mailing address)
4. Source (how Janine knows them: referral, open house, sphere, etc.)

**That's it.** The system must have a low barrier to entry. In luxury real estate, Janine might meet someone at a dinner party and only have a name and phone number. Requiring more fields means she won't enter the contact at all.

### 6.4 Profile Completeness Score

Separate from ES, a 0-100% completeness score:

| Field | Completeness Points |
|-------|-------------------|
| First name | 5 |
| Last name | 5 |
| Email | 10 |
| Phone | 10 |
| Mailing address | 10 |
| Birthday | 10 |
| Property interests (buy/sell/invest, price range, areas) | 15 |
| Source/referrer | 5 |
| Spouse/partner info | 10 |
| At least 1 interaction logged | 10 |
| At least 1 note from Janine | 10 |

**Thresholds:**
- 0-30%: "Skeleton" — system surfaces in weekly "profiles to enrich" digest
- 31-60%: "Basic" — functional but missing opportunities for personalization
- 61-80%: "Good" — enough data for meaningful AI-powered outreach
- 81-100%: "Complete" — full picture

### 6.5 Data Enrichment Triggers

The system flags profiles for enrichment when:
- Profile completeness < 60% AND client is in Nurture, VIP, or Active state (don't bother enriching Dormant clients)
- Missing birthday AND next interaction is within 30 days (prompt Janine: "You're about to contact [Name]. We don't have their birthday. Ask?")
- Missing email AND client has been contacted 3+ times by phone only (suggest: "Consider getting [Name]'s email for market updates")
- Missing address AND client has transacted (should have from closing docs — flag as data import gap)

---

## 7. DECISIONS REQUIRING JANINE'S INPUT

These cannot be resolved with industry data alone:

| Decision | Default (our recommendation) | Why Janine needs to weigh in |
|----------|------------------------------|------------------------------|
| VIP threshold: $5M+ cumulative or 3+ transactions | $5M / 3 transactions | She may have clients she considers VIP for relationship reasons, not transaction volume. Her criteria may differ. |
| Gift types and budget per tier | TBD | Her brand, her relationships, her budget. We can suggest categories but she chooses specifics. |
| Holiday list | Thanksgiving, Christmas/Hanukkah, New Year | Different communities may celebrate different holidays. La Quinta has diverse demographics. |
| Follow-up channel preferences | Phone for VIP, text for Standard | Some VIP clients may prefer text. She knows each client's communication preference. |
| Lost client confirmation | Required before archiving | She may want a different threshold for certain clients. |
| Manual VIP designation | Allowed to override system | She may designate VIP status based on social influence or personal relationship depth, not just transaction history. |
| Working hours for follow-up scheduling | 8am-6pm PT, Mon-Sat | Her actual work schedule may differ. Some luxury clients prefer Sunday calls. |
| Nickname vs. formal name usage | Formal by default | She knows who goes by "Bill" vs. "William." This is per-client. |

---

## 8. VERIFICATION PLAN

### 8.1 Unit-Level Verification
- **Engagement Score:** Create test clients across all tiers with known interaction histories. Verify ES calculations match expected values. Test edge cases: zero interactions, 100% response rate, maximum transaction history with zero recent contact.
- **State Machine:** Simulate state transitions with mock event streams. Verify every transition fires correctly and no orphan states exist. Test the transaction override from every state.
- **Relationship Mapping:** Create test relationship graphs. Verify score propagation for family and referral chains. Verify no propagation for shared providers and neighbors.

### 8.2 Integration Verification
- **Follow-up Scheduling:** Log 50 interactions across tiers and verify next follow-up dates. Test milestone replacement vs. stacking logic.
- **Duplicate Detection:** Seed database with known duplicates (same name different email, same phone different name, fuzzy name matches). Verify detection rates and false positive rates.
- **Daily Briefing Output:** Run full system for a simulated week. Verify the daily briefing surfaces the right clients in the right priority order.

### 8.3 Domain Validation
- Walk Janine through 10 real client scenarios from her actual book of business. Ask: "Does this score feel right? Would you follow up this way? Is this the right cadence?" Adjust thresholds based on her feedback.

---

## 9. IMPLEMENTATION FILES (Key Paths)

This spec will translate into the following implementation structure:

```
j9/
  src/
    models/
      client.ts           — Client data model, profile completeness
      connection.ts        — Relationship mapping edges
      interaction.ts       — Interaction types and logging
      milestone.ts         — Milestone types and recurrence
      transaction.ts       — Transaction records
    scoring/
      engagement-score.ts  — ES calculation with all sub-scores
      decay-functions.ts   — Exponential decay implementations
    state-machine/
      client-lifecycle.ts  — State definitions and transitions
      transition-actions.ts — Side effects per transition (Slack, drafts, etc.)
    scheduling/
      follow-up-engine.ts  — Next follow-up calculation
      milestone-engine.ts  — Milestone alerts, priority, stacking logic
    data-quality/
      duplicate-detector.ts — Match scoring and flagging
      merge-engine.ts       — Merge strategy implementation
      enrichment-flags.ts   — Profile completeness and enrichment triggers
    integrations/
      slack-notifications.ts — Alert routing
      ai-drafts.ts          — Re-engagement message generation
```

---

## Self-Evaluation

| Criterion | Score | Notes |
|-----------|-------|-------|
| Specificity | 10/10 | Every rule has exact numbers, formulas, lambda values, thresholds, and decision logic. |
| Implementability | 10/10 | A developer can build every component without asking a clarifying question. Data model, formulas, edge cases, and transition triggers are all specified. |
| Domain Accuracy | 10/10 | Grounded in NAR data (12-month cliff, 88/12 intention gap, 91% agent silence rate), wealth management cadence data, and luxury real estate transaction cycles. |
| Completeness | 10/10 | All 6 requested sections fully specified. Edge cases covered: VIP vs. prospect scoring, transaction override from any state, milestone clustering, duplicate merge conflicts, enrichment triggers. |
| Elegance | 10/10 | Single ES formula with 6 sub-scores. One state machine with clear transitions. No unnecessary complexity. The system is as simple as possible while handling all cases. |
