local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

---Acknowledge a pd incident
---@param incident any
M.acknowledge_incident = function(incident)
  local ackout = vim
    .system({ "pd", "incident", "acknowledge", "-i", incident.id }, { text = true }, function() end)
    :wait()
  if ackout.code ~= 0 then
    vim.notify("Error acknowledging Incident: " .. ackout.stderr)
    return
  end
  vim.notify("Acknowledged incident " .. incident.id)
end

M.acknowledge_all = function()
  local ackout = vim.system({ "pd", "incident", "acknowledge", "--me" }, { text = true }, function() end):wait()
  if ackout.code ~= 0 then
    vim.notify("Error acknowledging Incidents: " .. ackout.stderr)
    return
  end
  vim.notify("Acknowledged all Incidents: " .. ackout.stdout)
end

M.open_incident = function(incident)
  vim.system({ "xdg-open", incident.html_url }, {}, function() end)
end

M.yank_incident_info = function(incident)
  local out = vim
    .system({
      "zsh",
      "-c",
      "source /home/maschulz/dotfiles/private_addons; printIncidentHeader " .. incident.html_url,
    }, { text = true }, function() end)
    :wait()
  if out.code ~= 0 then
    vim.notify("Error: " .. out.stderr .. out.stdout)
    return
  end
  vim.fn.setreg("@", out.stdout)
  vim.notify("Incident info stored in unnamed register")
end

M.get_my_incidents = function()
  local pd_out = vim
    .system({ "pd", "incident", "list", "--me", "--json" }, {
      text = true,
    })
    :wait()
  if pd_out.code ~= 0 then
    vim.notify("Error getting pd incidents: " .. pd_out.stderr, vim.log.levels.ERROR)
    return {}
  end
  if pd_out.stdout == "" then
    vim.notify("No Incidents assigned to you", vim.log.levels.INFO)
    return {}
  end
  local incs = vim.fn.json_decode(pd_out.stdout)
  return incs
end

M.get_alerts_for_incident = function(incident_id)
  local pd_out = vim
    .system({ "pd", "incident", "alerts", "-i", incident_id, "--json" }, {
      text = true,
    })
    :wait()
  if pd_out.code ~= 0 then
    vim.notify("Error getting alerts for incident: " .. pd_out.stderr)
    return {}
  end

  return vim.fn.json_decode(pd_out.stdout)
end

M.pd_previewer = previewers.new_buffer_previewer({
  get_buffer_by_name = function(self, entry)
    return entry.value.id
  end,
  define_preview = function(self, entry, status)
    local target_buf = self.state.bufnr
    local bufname = self.state.bufname
    if not entry then
      return
    end
    if vim.api.nvim_buf_line_count(target_buf) > 2 then
      return
    end
    vim.api.nvim_buf_set_lines(target_buf, 0, -1, true, { "loading..." })
    require("telescope.previewers.utils").highlighter(target_buf, "markdown")
    local inc_id = entry.value.id
    require("telescope.previewers.utils").job_maker(
      { "pd", "incident", "alerts", "-i", inc_id, "--json" },
      target_buf,
      {
        callback = function(bufnr, content)
          local alerts = vim.fn.json_decode(content)
          local heading = "# " .. entry.value.title
          local assignees = ""
          for _, ass in ipairs(entry.value.assignments) do
            assignees = assignees .. '"' .. ass.assignee.summary .. '" '
          end
          local lines = {
            heading,
            "",
            "- *created at:* " .. entry.value.created_at,
            "- **id**: " .. entry.value.id,
            "- service: " .. entry.value.service.summary,
            "- Assignments: " .. assignees,
            "",
            "### alerts ",
          }

          for _, alert in ipairs(alerts) do
            table.insert(lines, "")
            table.insert(lines, "#### " .. alert.summary)
            table.insert(lines, "")
            if alert.body and alert.body.details then
              if alert.body.details.cluster_id then
                table.insert(lines, "- cluster_id: " .. alert.body.details.cluster_id)
              end
              if alert.body.details.firing then
                for _, val in ipairs(vim.split(alert.body.details.firing, "\n")) do
                  table.insert(lines, val)
                end
              end
            end
          end
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
        end,
      }
    )
  end,
})

M.Pick = function()
  pickers
    .new({}, {
      prompt_title = "pagerduty",
      finder = finders.new_table({
        results = M.get_my_incidents(),
        entry_maker = function(entry)
          return {
            valid = true,
            value = entry,
            ordinal = entry.created_at,
            display = "[" .. entry.status .. "]" .. " " .. entry.title,
          }
        end,
      }),
      previewer = M.pd_previewer,
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)

          local selection = action_state.get_selected_entry()
          if selection == nil or selection.value == nil then
            return true
          end
          M.ui(selection.value)
        end)

        return true
      end,
    })
    :find()
end

M.ui = function(incident)
  vim.ui.select({
    {
      text = "Open in Browser",
      value = "open",
    },
    {
      text = "Yank Incident Info",
      value = "yank",
    },
    {
      text = "Acknowledge Incident",
      value = "ack",
    },
    {
      text = "Acknowledge All Incidents",
      value = "ackall",
    },
  }, {
    prompt = "Action for incident " .. incident.summary,
    format_item = function(item)
      return item.text
    end,
  }, function(choice)
    vim.print(choice)
    if choice.value == "open" then
      M.open_incident(incident)
    elseif choice.value == "yank" then
      M.yank_incident_info(incident)
    elseif choice.value == "ack" then
      M.acknowledge_incident(incident)
    elseif choice.value == "ackall" then
      M.acknowledge_all()
    end
  end)
end

return M
