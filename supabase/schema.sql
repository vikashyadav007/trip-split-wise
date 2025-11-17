-- Trip Split Wise Database Schema
-- This schema defines tables for expense splitting with real-time capabilities

-- ============================================================================
-- USERS TABLE
-- ============================================================================
-- Synced with Supabase Auth, stores additional user profile information
CREATE TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL UNIQUE,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster user lookups
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- ============================================================================
-- GROUPS TABLE
-- ============================================================================
-- Represents expense groups (e.g., "Trip to Bali", "Roommate Expenses")
CREATE TABLE IF NOT EXISTS groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  created_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for faster group lookups by creator
CREATE INDEX IF NOT EXISTS idx_groups_created_by ON groups(created_by);

-- ============================================================================
-- GROUP_MEMBERS TABLE
-- ============================================================================
-- Many-to-many relationship between users and groups
CREATE TABLE IF NOT EXISTS group_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Ensure a user can only be in a group once
  UNIQUE(group_id, user_id)
);

-- Indexes for faster lookups
CREATE INDEX IF NOT EXISTS idx_group_members_group ON group_members(group_id);
CREATE INDEX IF NOT EXISTS idx_group_members_user ON group_members(user_id);

-- ============================================================================
-- EXPENSES TABLE
-- ============================================================================
-- Individual expenses within groups
CREATE TABLE IF NOT EXISTS expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
  description TEXT NOT NULL,
  amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0),
  paid_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  category TEXT,
  date DATE NOT NULL DEFAULT CURRENT_DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes for faster queries
CREATE INDEX IF NOT EXISTS idx_expenses_group ON expenses(group_id);
CREATE INDEX IF NOT EXISTS idx_expenses_paid_by ON expenses(paid_by);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date DESC);

-- ============================================================================
-- EXPENSE_SPLITS TABLE
-- ============================================================================
-- Tracks how each expense is split among group members
CREATE TABLE IF NOT EXISTS expense_splits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  expense_id UUID NOT NULL REFERENCES expenses(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  amount DECIMAL(10, 2) NOT NULL CHECK (amount >= 0),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  
  -- Ensure a user appears only once per expense split
  UNIQUE(expense_id, user_id)
);

-- Indexes for faster lookups
CREATE INDEX IF NOT EXISTS idx_expense_splits_expense ON expense_splits(expense_id);
CREATE INDEX IF NOT EXISTS idx_expense_splits_user ON expense_splits(user_id);

-- ============================================================================
-- TRIGGERS FOR UPDATED_AT
-- ============================================================================
-- Auto-update updated_at timestamp on record modification

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_groups_updated_at BEFORE UPDATE ON groups
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_expenses_updated_at BEFORE UPDATE ON expenses
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE group_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE expense_splits ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- USERS POLICIES
-- ============================================================================

-- Users can read all users (for adding members to groups)
CREATE POLICY "Users can read all users"
  ON users FOR SELECT
  USING (true);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON users FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON users FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- ============================================================================
-- GROUPS POLICIES
-- ============================================================================

-- Users can read groups they're members of
CREATE POLICY "Users can read groups they're members of"
  ON groups FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM group_members
      WHERE group_members.group_id = groups.id
      AND group_members.user_id = auth.uid()
    )
  );

-- Users can create groups
CREATE POLICY "Users can create groups"
  ON groups FOR INSERT
  WITH CHECK (auth.uid() = created_by);

-- Group creators can update their groups
CREATE POLICY "Group creators can update groups"
  ON groups FOR UPDATE
  USING (auth.uid() = created_by)
  WITH CHECK (auth.uid() = created_by);

-- Group creators can delete their groups
CREATE POLICY "Group creators can delete groups"
  ON groups FOR DELETE
  USING (auth.uid() = created_by);

-- ============================================================================
-- GROUP_MEMBERS POLICIES
-- ============================================================================

-- Users can read group members for groups they're in
CREATE POLICY "Users can read group members"
  ON group_members FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM group_members gm
      WHERE gm.group_id = group_members.group_id
      AND gm.user_id = auth.uid()
    )
  );

-- Group creators can add members
CREATE POLICY "Group creators can add members"
  ON group_members FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM groups
      WHERE groups.id = group_members.group_id
      AND groups.created_by = auth.uid()
    )
  );

-- Group creators and the member themselves can remove members
CREATE POLICY "Group creators and members can remove members"
  ON group_members FOR DELETE
  USING (
    auth.uid() = user_id OR
    EXISTS (
      SELECT 1 FROM groups
      WHERE groups.id = group_members.group_id
      AND groups.created_by = auth.uid()
    )
  );

-- ============================================================================
-- EXPENSES POLICIES
-- ============================================================================

-- Users can read expenses from groups they're members of
CREATE POLICY "Users can read expenses from their groups"
  ON expenses FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM group_members
      WHERE group_members.group_id = expenses.group_id
      AND group_members.user_id = auth.uid()
    )
  );

-- Group members can create expenses
CREATE POLICY "Group members can create expenses"
  ON expenses FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM group_members
      WHERE group_members.group_id = expenses.group_id
      AND group_members.user_id = auth.uid()
    )
  );

-- Expense creators can update their expenses
CREATE POLICY "Expense creators can update expenses"
  ON expenses FOR UPDATE
  USING (auth.uid() = paid_by)
  WITH CHECK (auth.uid() = paid_by);

-- Expense creators can delete their expenses
CREATE POLICY "Expense creators can delete expenses"
  ON expenses FOR DELETE
  USING (auth.uid() = paid_by);

-- ============================================================================
-- EXPENSE_SPLITS POLICIES
-- ============================================================================

-- Users can read splits for expenses in their groups
CREATE POLICY "Users can read expense splits from their groups"
  ON expense_splits FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM expenses
      JOIN group_members ON group_members.group_id = expenses.group_id
      WHERE expenses.id = expense_splits.expense_id
      AND group_members.user_id = auth.uid()
    )
  );

-- Expense creators can manage splits for their expenses
CREATE POLICY "Expense creators can insert splits"
  ON expense_splits FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM expenses
      WHERE expenses.id = expense_splits.expense_id
      AND expenses.paid_by = auth.uid()
    )
  );

CREATE POLICY "Expense creators can update splits"
  ON expense_splits FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM expenses
      WHERE expenses.id = expense_splits.expense_id
      AND expenses.paid_by = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM expenses
      WHERE expenses.id = expense_splits.expense_id
      AND expenses.paid_by = auth.uid()
    )
  );

CREATE POLICY "Expense creators can delete splits"
  ON expense_splits FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM expenses
      WHERE expenses.id = expense_splits.expense_id
      AND expenses.paid_by = auth.uid()
    )
  );

-- ============================================================================
-- REALTIME PUBLICATION
-- ============================================================================
-- Enable Realtime for all tables (configure in Supabase Dashboard > Replication)
-- Tables: users, groups, group_members, expenses, expense_splits

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Function to get balance summary for a user in a group
CREATE OR REPLACE FUNCTION get_user_balance_in_group(
  p_user_id UUID,
  p_group_id UUID
)
RETURNS DECIMAL(10, 2) AS $$
DECLARE
  total_paid DECIMAL(10, 2);
  total_owed DECIMAL(10, 2);
BEGIN
  -- Calculate total amount user paid
  SELECT COALESCE(SUM(amount), 0)
  INTO total_paid
  FROM expenses
  WHERE group_id = p_group_id AND paid_by = p_user_id;
  
  -- Calculate total amount user owes
  SELECT COALESCE(SUM(amount), 0)
  INTO total_owed
  FROM expense_splits
  JOIN expenses ON expenses.id = expense_splits.expense_id
  WHERE expenses.group_id = p_group_id AND expense_splits.user_id = p_user_id;
  
  -- Return net balance (positive = owed to user, negative = user owes)
  RETURN total_paid - total_owed;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get all balances for a group
CREATE OR REPLACE FUNCTION get_group_balances(p_group_id UUID)
RETURNS TABLE(
  user_id UUID,
  user_name TEXT,
  balance DECIMAL(10, 2)
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    u.id,
    u.display_name,
    get_user_balance_in_group(u.id, p_group_id) as balance
  FROM users u
  JOIN group_members gm ON gm.user_id = u.id
  WHERE gm.group_id = p_group_id
  ORDER BY balance DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
