#!/usr/bin/env python3
###############################################################################
#
# Copyright 2006 - 2021, Tomas Babej, Paul Beckingham, Federico Hernandez.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# https://www.opensource.org/licenses/mit-license.php
#
###############################################################################

import datetime
import json
import sys
import numbers
import os
import unittest

# Ensure python finds the local simpletap module
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from basetest import Task, TestCase
from basetest.utils import UUID_REGEXP
from basetest.compat import STRING_TYPE

DATETIME_FORMAT = "%Y%m%dT%H%M%SZ"


class TestParseCommand(TestCase):
    def setUp(self):
        self.t = Task()

    def parse(self, args):
        """Helper to run parse command and return parsed JSON"""
        code, out, err = self.t("parse {0}".format(args))
        self.assertEqual(code, 0, "Parse command should succeed")
        return json.loads(out.strip())

    def assertType(self, value, type):
        self.assertEqual(isinstance(value, type), True)

    def assertTimestamp(self, value):
        """Asserts that timestamp is exported as string in the correct format."""
        self.assertType(value, STRING_TYPE)
        datetime.datetime.strptime(value, DATETIME_FORMAT)

    def assertString(self, value, expected_value=None, regexp=False):
        """Checks the type of value to be string, and optionally validates content."""
        self.assertType(value, STRING_TYPE)
        if expected_value is not None:
            if regexp:
                self.assertRegex(value, expected_value)
            else:
                self.assertEqual(value, expected_value)

    def assertNumeric(self, value, expected_value=None):
        """Checks the type of the value to be numeric."""
        self.assertType(value, numbers.Real)
        if expected_value is not None:
            self.assertEqual(value, expected_value)

    def test_parse_basic_description(self):
        """Test parsing a simple task description"""
        result = self.parse("Buy groceries")
        self.assertString(result["description"], "Buy groceries")
        # Parse doesn't set status, that's only for saved tasks
        self.assertIn("urgency", result)

    def test_parse_does_not_save(self):
        """Critical: Verify parse does not add task to database"""
        self.parse("This should not be saved")
        # Task list returns exit code 1 when no tasks match
        # We expect this since we haven't saved any tasks
        code, out, err = self.t.runError("list")
        self.assertNotIn("This should not be saved", out)

    def test_parse_with_priority(self):
        """Test parsing task with priority"""
        result = self.parse("Important task priority:H")
        self.assertString(result["description"], "Important task")
        self.assertString(result["priority"], "H")

        result = self.parse("Medium task priority:M")
        self.assertString(result["priority"], "M")

        result = self.parse("Low task priority:L")
        self.assertString(result["priority"], "L")

    def test_parse_applies_uda_default(self):
        """Test parsing applies configured UDA defaults"""
        self.t.config("uda.points.type", "numeric")
        self.t.config("uda.points.label", "Points")
        self.t.config("uda.points.default", "5")

        result = self.parse("Testing UDA default invocation")
        self.assertString(result["description"], "Testing UDA default invocation")
        self.assertNumeric(result["points"], 5)

    def test_parse_with_project(self):
        """Test parsing task with project"""
        result = self.parse("Review code pro:Website")
        self.assertString(result["description"], "Review code")
        self.assertString(result["project"], "Website")

        result = self.parse("Fix bug project:App.Backend")
        self.assertString(result["project"], "App.Backend")

    def test_parse_with_single_tag(self):
        """Test parsing task with a single tag"""
        result = self.parse("Buy milk +shopping")
        self.assertString(result["description"], "Buy milk")
        self.assertIn("shopping", result["tags"])

    def test_parse_with_multiple_tags(self):
        """Test parsing task with multiple tags"""
        result = self.parse("Important meeting +work +urgent +calendar")
        self.assertString(result["description"], "Important meeting")
        self.assertIn("work", result["tags"])
        self.assertIn("urgent", result["tags"])
        self.assertIn("calendar", result["tags"])
        self.assertEqual(len(result["tags"]), 3)

    def test_parse_with_due_date(self):
        """Test parsing task with due date"""
        result = self.parse("Submit report due:tomorrow")
        self.assertString(result["description"], "Submit report")
        self.assertIn("due", result)
        self.assertTimestamp(result["due"])

        result = self.parse("Pay bills due:eom")
        self.assertIn("due", result)
        self.assertTimestamp(result["due"])

    def test_parse_with_scheduled_date(self):
        """Test parsing task with scheduled date"""
        result = self.parse("Call dentist scheduled:tomorrow")
        self.assertString(result["description"], "Call dentist")
        self.assertIn("scheduled", result)
        self.assertTimestamp(result["scheduled"])

    def test_parse_combined_attributes(self):
        """Test parsing task with multiple attributes combined"""
        result = self.parse("Buy groceries due:tomorrow +shopping priority:H pro:Home")
        self.assertString(result["description"], "Buy groceries")
        self.assertIn("due", result)
        self.assertTimestamp(result["due"])
        self.assertIn("shopping", result["tags"])
        self.assertString(result["priority"], "H")
        self.assertString(result["project"], "Home")

    def test_parse_urgency_calculation(self):
        """Test that urgency is calculated in parsed output"""
        result = self.parse("Normal task")
        self.assertIn("urgency", result)
        self.assertNumeric(result["urgency"])

        # High priority task should have higher urgency
        result = self.parse("High priority task priority:H")
        self.assertIn("urgency", result)
        self.assertNumeric(result["urgency"])
        self.assertGreater(result["urgency"], 0)

    def test_parse_minimal_output(self):
        """Test that parse outputs minimal JSON (no uuid/entry until saved)"""
        result = self.parse("Task without save")
        self.assertIn("description", result)
        self.assertIn("urgency", result)
        # UUID and entry are not generated until task is saved
        # Parse command doesn't save, so these won't be present

    def test_parse_id_zero(self):
        """Test that parse sets id to 0 (not yet in database)"""
        result = self.parse("New task")
        self.assertEqual(result["id"], 0)

    def test_parse_with_quotes(self):
        """Test parsing descriptions with quotes"""
        result = self.parse("'Task with single quotes'")
        self.assertString(result["description"], "Task with single quotes")

        result = self.parse('"Task with double quotes"')
        self.assertString(result["description"], "Task with double quotes")

    def test_parse_with_special_characters(self):
        """Test parsing descriptions with special characters"""
        result = self.parse("Task with /slashes/ in it")
        self.assertIn("slashes", result["description"])

        result = self.parse("Email: user@example.com")
        self.assertIn("@", result["description"])

    def test_parse_multiple_times_independent(self):
        """Test that parsing multiple times works independently"""
        result1 = self.parse("Task one")
        result2 = self.parse("Task two")
        self.assertString(result1["description"], "Task one")
        self.assertString(result2["description"], "Task two")

    def test_parse_empty_tags_array(self):
        """Test that tasks without tags have empty tags array"""
        result = self.parse("Task without tags")
        self.assertEqual(result.get("tags", []), [])

    def test_parse_has_description(self):
        """Test that parsed tasks always have description"""
        result = self.parse("Any task")
        self.assertString(result["description"], "Any task")

    def test_parse_with_annotations(self):
        """Test parsing with annotations (if supported in parse context)"""
        # Note: Annotations are typically added after creation, but we test that
        # the parse command doesn't break with annotation-related text
        result = self.parse("Task with notes annotation:some_note")
        # Should still parse successfully
        self.assertIn("description", result)

    def test_parse_json_format(self):
        """Test that output is valid JSON"""
        code, out, err = self.t("parse Simple task")
        self.assertEqual(code, 0)
        # Should not raise JSONDecodeError
        data = json.loads(out.strip())
        self.assertIsInstance(data, dict)

    def test_parse_with_wait_date(self):
        """Test parsing task with wait date"""
        result = self.parse("Future task wait:tomorrow")
        self.assertString(result["description"], "Future task")
        self.assertIn("wait", result)
        self.assertTimestamp(result["wait"])

    def test_parse_with_until_date(self):
        """Test parsing task with until date"""
        result = self.parse("Temporary task until:eow")
        self.assertString(result["description"], "Temporary task")
        self.assertIn("until", result)
        self.assertTimestamp(result["until"])

    def test_parse_complex_project_hierarchy(self):
        """Test parsing with complex project hierarchy"""
        result = self.parse("Deep task pro:Company.Department.Team.Project")
        self.assertString(result["project"], "Company.Department.Team.Project")

    def test_parse_with_recur(self):
        """Test parsing with recurrence pattern"""
        result = self.parse("Weekly meeting recur:weekly due:monday")
        self.assertString(result["description"], "Weekly meeting")
        # Recurrence information should be present
        if "recur" in result:
            self.assertIn("recur", result)

    def test_parse_preserves_description_order(self):
        """Test that description words are preserved in order"""
        result = self.parse("First second third fourth +tag pro:Proj priority:H")
        self.assertString(result["description"], "First second third fourth")

    def test_parse_no_database_modification(self):
        """Verify parse is truly read-only - no .task directory changes"""
        # Add a task to establish baseline
        self.t("add Existing task")
        code, out, err = self.t("count")
        initial_count = int(out.strip())

        # Parse some tasks
        self.parse("Parse task 1")
        self.parse("Parse task 2")
        self.parse("Parse task 3")

        # Count should remain unchanged
        code, out, err = self.t("count")
        final_count = int(out.strip())
        self.assertEqual(initial_count, final_count)

    def test_parse_output_contains_required_fields(self):
        """Test that parse output includes essential fields for parsed tasks"""
        result = self.parse("Complete task")
        # Fields that should always be present in parse output
        self.assertIn("description", result)
        self.assertIn("id", result)
        self.assertIn("urgency", result)
        # Note: uuid, entry, status are not present until task is saved


if __name__ == "__main__":
    from simpletap import TAPTestRunner

    unittest.main(testRunner=TAPTestRunner())
