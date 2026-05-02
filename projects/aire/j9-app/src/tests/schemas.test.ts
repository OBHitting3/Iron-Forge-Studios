import { describe, it, expect } from "vitest";
import {
  createClientSchema,
  updateClientSchema,
  logInteractionSchema,
  addMilestoneSchema,
  createTransactionSchema,
} from "../validation/schemas.js";

describe("createClientSchema", () => {
  it("accepts valid minimal input", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
    });
    expect(result.success).toBe(true);
  });

  it("accepts full input with all optional fields", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
      email: "janine@example.com",
      phone: "760-555-1234",
      relationship_type: "client",
      relationship_tier: "vip",
      source: "referral",
      birthday: "1960-03-15",
      anniversary: "1985-06-20",
      interests: "golf, wine, mid-century architecture",
      preferred_communities: ["Madison Club", "PGA West"],
      price_range_low: 2000000,
      price_range_high: 5000000,
      is_buyer: true,
      is_seller: false,
    });
    expect(result.success).toBe(true);
  });

  it("rejects missing first_name", () => {
    const result = createClientSchema.safeParse({ last_name: "Stevens" });
    expect(result.success).toBe(false);
  });

  it("rejects missing last_name", () => {
    const result = createClientSchema.safeParse({ first_name: "Janine" });
    expect(result.success).toBe(false);
  });

  it("rejects invalid email", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
      email: "not-an-email",
    });
    expect(result.success).toBe(false);
  });

  it("accepts empty string email", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
      email: "",
    });
    expect(result.success).toBe(true);
  });

  it("rejects invalid relationship_type", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
      relationship_type: "friend",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid relationship_tier", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
      relationship_tier: "platinum",
    });
    expect(result.success).toBe(false);
  });

  it("rejects negative price_range_low", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
      price_range_low: -100,
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid date format for birthday", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
      birthday: "March 15, 1960",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid date format for anniversary", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
      anniversary: "06/20/1985",
    });
    expect(result.success).toBe(false);
  });

  it("defaults relationship_type to client", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
    });
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.relationship_type).toBe("client");
    }
  });

  it("defaults is_buyer and is_seller to false", () => {
    const result = createClientSchema.safeParse({
      first_name: "Janine",
      last_name: "Stevens",
    });
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.is_buyer).toBe(false);
      expect(result.data.is_seller).toBe(false);
    }
  });
});

describe("updateClientSchema", () => {
  it("accepts partial updates", () => {
    const result = updateClientSchema.safeParse({ phone: "760-555-9999" });
    expect(result.success).toBe(true);
  });

  it("accepts empty object", () => {
    const result = updateClientSchema.safeParse({});
    expect(result.success).toBe(true);
  });

  it("still validates field types", () => {
    const result = updateClientSchema.safeParse({ email: "not-valid" });
    expect(result.success).toBe(false);
  });
});

describe("logInteractionSchema", () => {
  it("accepts valid interaction", () => {
    const result = logInteractionSchema.safeParse({
      interaction_type: "call",
      direction: "outbound",
      content: "Discussed listing at 45678 Via Esperanza",
    });
    expect(result.success).toBe(true);
  });

  it("accepts minimal interaction", () => {
    const result = logInteractionSchema.safeParse({
      interaction_type: "note",
    });
    expect(result.success).toBe(true);
  });

  it("rejects invalid interaction_type", () => {
    const result = logInteractionSchema.safeParse({
      interaction_type: "fax",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid direction", () => {
    const result = logInteractionSchema.safeParse({
      interaction_type: "call",
      direction: "sideways",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid follow_up_date format", () => {
    const result = logInteractionSchema.safeParse({
      interaction_type: "call",
      follow_up_date: "next Tuesday",
    });
    expect(result.success).toBe(false);
  });

  it("accepts valid follow_up_date", () => {
    const result = logInteractionSchema.safeParse({
      interaction_type: "call",
      follow_up_date: "2026-05-15",
      follow_up_needed: true,
    });
    expect(result.success).toBe(true);
  });

  it("defaults direction to outbound", () => {
    const result = logInteractionSchema.safeParse({
      interaction_type: "email",
    });
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.direction).toBe("outbound");
    }
  });
});

describe("addMilestoneSchema", () => {
  it("accepts valid milestone", () => {
    const result = addMilestoneSchema.safeParse({
      milestone_type: "birthday",
      title: "Janine's Birthday",
      milestone_date: "1960-03-15",
      recurring: true,
    });
    expect(result.success).toBe(true);
  });

  it("rejects missing title", () => {
    const result = addMilestoneSchema.safeParse({
      milestone_type: "closing",
      milestone_date: "2026-06-01",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid milestone_type", () => {
    const result = addMilestoneSchema.safeParse({
      milestone_type: "graduation",
      title: "Kid graduated",
      milestone_date: "2026-06-15",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid date format", () => {
    const result = addMilestoneSchema.safeParse({
      milestone_type: "birthday",
      title: "Birthday",
      milestone_date: "March 15",
    });
    expect(result.success).toBe(false);
  });
});

describe("createTransactionSchema", () => {
  it("accepts valid transaction", () => {
    const result = createTransactionSchema.safeParse({
      transaction_type: "purchase",
      property_address: "45678 Via Esperanza, Indian Wells, CA 92210",
      list_price: 4500000,
      representing: "buyer",
    });
    expect(result.success).toBe(true);
  });

  it("accepts minimal transaction", () => {
    const result = createTransactionSchema.safeParse({
      transaction_type: "sale",
      property_address: "123 Main St",
    });
    expect(result.success).toBe(true);
  });

  it("rejects missing property_address", () => {
    const result = createTransactionSchema.safeParse({
      transaction_type: "sale",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid transaction_type", () => {
    const result = createTransactionSchema.safeParse({
      transaction_type: "swap",
      property_address: "123 Main St",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid representing value", () => {
    const result = createTransactionSchema.safeParse({
      transaction_type: "purchase",
      property_address: "123 Main St",
      representing: "both",
    });
    expect(result.success).toBe(false);
  });

  it("rejects invalid listing_date format", () => {
    const result = createTransactionSchema.safeParse({
      transaction_type: "sale",
      property_address: "123 Main St",
      listing_date: "Jan 1 2026",
    });
    expect(result.success).toBe(false);
  });

  it("defaults status to active", () => {
    const result = createTransactionSchema.safeParse({
      transaction_type: "purchase",
      property_address: "123 Main St",
    });
    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.status).toBe("active");
    }
  });
});
