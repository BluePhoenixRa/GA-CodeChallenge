// Search Bar Animations w/jQuery :: For some flair
$(function(){
	var searchField = $('#query');
	var icon = $('#search-btn');

	$(searchField).on('focus', function(){
		$(this).animate({
			width:'100%'
		},400);
		$(icon).animate({
			right: '10px'
		}, 400);
	});

	$(searchField).on('blur', function(){
		if(searchField.val() == ''){
			$(searchField).animate({
				width:'45%'
			},400, function(){});
			$(icon).animate({
				right:'360px'
			},400, function(){});
		}
	});

	$('#search-form').submit(function(e){
		e.preventDefault();
	});
});

// Search Function
function search(){
	// Clear Results
	$('#results').html('');

	// Get Input From Form
	search = $('#query').val();

	// Run GET Request by passing the input value, movie name, to the OMDb API.
	$.get(
		"http://www.omdbapi.com/",{
			s: search},
			function(data){

				// Log Data Acquired From OMDb API
				console.log(data);

				$.each(data.Search, function(i, Search){
					// Get Output
					var output = getOutput(Search);

					// Display Results
					$('#results').append(output);
				});

			}
	);
}

// Search Output Function
function getOutput(Search){
	var title = Search.Title;
	var year = Search.Year;
	var imdb = Search.imdbID;

	// Log Acquired Values
	console.log("Title of your movie: " + title);

	// Parse through output and place in rows
	var output = '<tr><td>' + title + '</td><td>' + year + '</td><td>' + '<a class="fancybox fancybox.iframe" href="/details/'+imdb+'">Details</a></td></tr>';

	return output;
}
