function on_crypt_change(crypt_type)
	{
        if (crypt_type != "<%= Launcher::CRYPT_TYPE_EXTERNAL %>")
        {
            // 需要加密，加载EXE
            myajax = jQuery.ajax({
                url: "/admin/release/get_exe_files",
                async: true,
                data: "game_name=" + $('#game_name').val() + "&file_dir=" + $('#file_dir').val(),
                success: function(data) {
                    $("#exe_path_name").empty();

                    if(data.length > 0)
                    {
                        for(var i=0; i<data.length; i++)
                            $('#exe_path_name').append("<option value='" + data[i] + "'" + ((data[i]=="<%= params[:exe_path_name] %>")? "selected='selected'" : "")  + ">" + data[i] + "</option>");

                        $('#exe_path_name').attr('disabled', false);
                    }
                    else
                    {
                        $('#exe_path_name').append("<option value=''>无可供加密的文件</option>");
                        $('#exe_path_name').attr('disabled', true);
                    }
                }
            });

        }
        else
                {
                    // 不需要加密，disable EXE选择
                    $("#exe_path_name").empty();
                    $('#exe_path_name').append("<option value=''></option>");
                    $('#exe_path_name').attr('disabled', true);
                    }
        }

function on_update_game_files_click()
	{
        var disabled = !$('#update_game_files').attr('checked');

        $('#file_dir').attr('disabled', disabled);
        $('#crypt_type').attr('disabled', disabled);

        if (disabled)
        $('#exe_path_name').attr('disabled', true);
        else
        on_crypt_change($('#crypt_type').val());
        }


$(document).ready(function()
	{
        on_update_game_files_click();
        })
