////////////////////////////////////////////////////////////////////////////////
//
// Copyright 2006 - 2021, Tomas Babej, Paul Beckingham, Federico Hernandez.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// https://www.opensource.org/licenses/mit-license.php
//
////////////////////////////////////////////////////////////////////////////////

#include <cmake.h>
// cmake.h include header must come first

#include <CmdParse.h>
#include <Context.h>
#include <Task.h>

////////////////////////////////////////////////////////////////////////////////
CmdParse::CmdParse() {
  _keyword = "parse";
  _usage = "task          parse <mods>";
  _description = "Parses task description and outputs JSON without saving";
  _read_only = true;
  _displays_id = false;
  _needs_gc = false;
  _needs_recur_update = false;
  _uses_context = false;
  _accepts_filter = false;
  _accepts_modifications = true;
  _accepts_miscellaneous = false;
  _category = Command::Category::misc;
}

////////////////////////////////////////////////////////////////////////////////
int CmdParse::execute(std::string& output) {
  // Create an empty task
  Task task;

  // Apply the command line modifications to the task.
  // This is identical to CmdAdd - it parses all the attributes
  // (due:, project:, tags, priority:, etc.) and populates the Task object.
  task.modify(Task::modReplace, true);

  // Output the parsed task as JSON.
  // Note: We use composeJSON(true) to get a decorated/complete JSON output
  // This includes urgency calculations and all task attributes.
  output += task.composeJSON(true);
  output += '\n';

  // Important: We do NOT call Context::getContext().tdb2.add(task)
  // This means the task is parsed but never saved to the database.

  return 0;
}

////////////////////////////////////////////////////////////////////////////////
